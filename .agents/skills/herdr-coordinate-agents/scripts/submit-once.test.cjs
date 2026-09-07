'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { dispatch, inspectReceipt } = require('./submit-once.cjs');

function fixture(t) {
  const parent = fs.realpathSync(os.tmpdir());
  const root = fs.mkdtempSync(path.join(parent, 'bale-protocol-test-'));
  t.after(() => {
    const resolved = fs.realpathSync(root);
    assert.equal(path.dirname(resolved), parent);
    assert.ok(path.basename(resolved).startsWith('bale-protocol-test-'));
    fs.rmSync(resolved, { recursive: true });
  });
  const job = { task_id: 'task', attempt_id: 'a1', target: 'worker', pane_id: 'p1',
    terminal_id: 't1', workspace_id: 'w1', cwd: root,
    prompt_file: path.join(root, 'packet.md'), receipt_file: path.join(root, 'receipt.json'),
    configuration_evidence: path.join(root, 'config.txt'), expected_outputs: ['output.txt'], context_files: [] };
  fs.writeFileSync(job.prompt_file, 'Literal multiline task\n`echo nope` $(nope) "quotes"');
  fs.writeFileSync(job.configuration_evidence, 'test configuration evidence');
  const save = () => fs.writeFileSync(path.join(root, 'job.json'), JSON.stringify(job));
  save();
  const receipt = { task_id: 'task', attempt_id: 'a1', status: 'completed',
    outputs: ['output.txt'], checks: [{ command: 'actual check', exit_code: 0 }], summary: 'result' };
  const result = () => {
    fs.writeFileSync(path.join(root, 'output.txt'), 'artifact');
    fs.writeFileSync(job.receipt_file, JSON.stringify(receipt));
  };
  const calls = [];
  const agent = { ...job, agent: 'codex', agent_status: 'idle' };
  const caller = { agent: 'codex', pane_id: 'coordinator', terminal_id: 'ct1', workspace_id: 'cw1' };
  const transport = args => { calls.push(args); return { result: { agent:
    ['coordinator','bale'].includes(args[2]) ? caller : agent } }; };
  return { root, job, save, receipt, result, calls, agent, caller, transport };
}
const env = { HERDR_ENV: '1', HERDR_PANE_ID: 'coordinator' };
test('literal prompt delivered once; receipt inspection does not claim semantic acceptance', t => {
  const f = fixture(t);
  assert.equal(dispatch(f.root, f.transport, env).state, 'submitted');
  assert.equal(f.calls.find(args => args[1] === 'prompt')[3], fs.readFileSync(f.job.prompt_file, 'utf8'));
  assert.equal(f.calls.find(args => args[1] === 'prompt')[2], 'p1');
  assert.throws(() => dispatch(f.root, f.transport, env), /already claimed/);
  assert.equal(f.calls.filter(args => args[1] === 'prompt').length, 1);
  f.result();
  assert.equal(inspectReceipt(f.root).state, 'receipt-inspected');
});
test('timeout after send leaves a claim and cannot cause resubmission after restart', t => {
  const f = fixture(t);
  let prompts = 0;
  const transport = args => {
    if (args[1] === 'prompt') { prompts++; throw new Error('timeout'); }
    return f.transport(args);
  };
  assert.throws(() => dispatch(f.root, transport, env), /Delivery uncertain/);
  assert.throws(() => dispatch(f.root, transport, env), /already claimed/);
  assert.equal(prompts, 1);
  f.result();
  assert.equal(inspectReceipt(f.root).attempt_id, 'a1');
});
test('worker/outside session and replaced or busy target cannot submit', t => {
  const f = fixture(t);
  assert.throws(() => dispatch(f.root, f.transport, {}), /Herdr-managed/);
  assert.throws(() => dispatch(f.root, f.transport, { ...env, HARNESS_ROLE: 'worker' }), /Workers/);
  f.agent.terminal_id = 'replacement';
  assert.throws(() => dispatch(f.root, f.transport, env), /terminal_id changed/);
  f.agent.terminal_id = 't1'; f.agent.agent_status = 'working';
  assert.throws(() => dispatch(f.root, f.transport, env), /not ready/);
  assert.ok(f.calls.every(args => args[1] === 'get'));
});
test('wrong attempt, missing evidence, failed check and changed packet are rejected', t => {
  const f = fixture(t);
  dispatch(f.root, f.transport, env); f.result();
  f.receipt.attempt_id = 'old'; f.result();
  assert.throws(() => inspectReceipt(f.root), /attempt_id mismatch/);
  f.receipt.attempt_id = 'a1'; f.receipt.checks = []; f.result();
  assert.throws(() => inspectReceipt(f.root), /reported checks/);
  f.receipt.checks = [{ command: 'test', exit_code: 1 }]; f.result();
  assert.throws(() => inspectReceipt(f.root), /reported checks/);
  f.receipt.checks[0].exit_code = 0; f.result();
  fs.unlinkSync(path.join(f.root, 'output.txt'));
  assert.throws(() => inspectReceipt(f.root), /Missing output/);
  f.result(); fs.appendFileSync(f.job.prompt_file, 'changed');
  assert.throws(() => inspectReceipt(f.root), /Packet changed/);
});
test('output traversal and alias paths are rejected before sending', t => {
  const f = fixture(t);
  for (const output of ['../escape', '/absolute', 'a/../b', 'a\\b', 'C:escape', './alias']) {
    f.job.expected_outputs = [output]; f.save();
    assert.throws(() => dispatch(f.root, f.transport, env));
  }
  assert.equal(f.calls.length, 0);
});
test('two callers racing after the initial existence check still send only once', t => {
  const f = fixture(t);
  let entered = false, sends = 0;
  const transport = args => {
    if (args[1] === 'get' && args[2] === 'worker' && !entered) {
      entered = true;
      dispatch(f.root, transport, env);
    }
    if (args[1] === 'prompt') sends++;
    return f.transport(args);
  };
  assert.throws(() => dispatch(f.root, transport, env), /EEXIST/);
  assert.equal(sends, 1);
});
test('another primary without Bale ownership is rejected', t => {
  const f = fixture(t);
  const transport = args => args[2] === 'bale' ? { result: { agent: { ...f.caller, terminal_id: 'other' } } } : f.transport(args);
  assert.throws(() => dispatch(f.root, transport, env), /does not own/);
  assert.ok(f.calls.every(args => args[1] !== 'prompt'));
});
test('immutable job and referenced context detect post-dispatch changes', t => {
  const f = fixture(t);
  const input = path.join(f.root, 'source.txt'); fs.writeFileSync(input, 'input');
  f.job.context_files = [input]; f.save();
  dispatch(f.root, f.transport, env); f.result();
  f.job.expected_outputs = ['other.txt']; f.save();
  assert.throws(() => inspectReceipt(f.root), /immutable job/);
  f.job.expected_outputs = ['output.txt']; f.save();
  fs.writeFileSync(input, 'changed');
  assert.throws(() => inspectReceipt(f.root), /Context changed/);
});
test('outputs cannot overwrite control files', t => {
  const f = fixture(t);
  f.job.expected_outputs = ['receipt.json']; f.save();
  assert.throws(() => dispatch(f.root, f.transport, env), /collides/);
});
