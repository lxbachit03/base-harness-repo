'use strict';

const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { spawnSync } = require('node:child_process');

const digest = value => crypto.createHash('sha256').update(value).digest('hex');
const readJson = file => JSON.parse(fs.readFileSync(file, 'utf8').replace(/^\uFEFF/, ''));
function requireValue(condition, message) {
  if (!condition) throw new Error(message);
}
function regularFile(file) {
  requireValue(fs.lstatSync(file).isFile(), `Expected regular file: ${file}`);
}
function loadJob(directory) {
  requireValue(path.isAbsolute(directory), 'Attempt directory must be absolute');
  const manifest = fs.readFileSync(path.join(directory, 'job.json'));
  const job = JSON.parse(manifest.toString('utf8').replace(/^\uFEFF/, ''));
  Object.defineProperty(job, 'manifestHash', { value: digest(manifest) });
  for (const key of ['task_id', 'attempt_id', 'target', 'pane_id', 'terminal_id',
    'workspace_id', 'cwd', 'prompt_file', 'receipt_file', 'configuration_evidence']) {
    requireValue(typeof job[key] === 'string' && job[key].trim(), `Missing ${key}`);
  }
  for (const key of ['cwd', 'prompt_file', 'receipt_file', 'configuration_evidence']) {
    requireValue(path.isAbsolute(job[key]), `${key} must be absolute`);
  }
  requireValue(Array.isArray(job.expected_outputs) && job.expected_outputs.length > 0,
    'expected_outputs must be nonempty');
  requireValue(new Set(job.expected_outputs).size === job.expected_outputs.length,
    'Duplicate expected output');
  for (const output of job.expected_outputs) outputPath(job.cwd, output, false);
  requireValue(Array.isArray(job.context_files) && job.context_files.every(file =>
    typeof file === 'string' && path.isAbsolute(file)), 'context_files must list absolute referenced inputs (or be empty)');
  const receiptRelative = path.relative(job.cwd, job.receipt_file).split(path.sep).join('/');
  outputPath(job.cwd, receiptRelative, false);
  const controls = [job.prompt_file, job.receipt_file, job.configuration_evidence,
    ...job.context_files, path.join(directory, 'job.json'), path.join(directory, 'dispatch.json')];
  for (const output of job.expected_outputs) {
    requireValue(controls.every(file => path.relative(path.resolve(job.cwd, output), file) !== ''),
      'Output collides with task input or control file');
  }
  return job;
}
function outputPath(root, relative, mustExist = true) {
  requireValue(typeof relative === 'string' && relative.length > 0 &&
    !path.isAbsolute(relative) && !/[:\\]/.test(relative), 'Output must be a portable relative path');
  const parts = relative.split('/');
  requireValue(parts.every(part => part && part !== '.' && part !== '..'), 'Output path escapes or aliases cwd');
  const base = fs.realpathSync(root);
  let current = base;
  for (const part of parts) {
    current = path.join(current, part);
    if (fs.existsSync(current)) {
      requireValue(!fs.lstatSync(current).isSymbolicLink(), 'Output path traverses a symlink');
    } else if (mustExist) throw new Error(`Missing output: ${relative}`);
  }
  if (mustExist) regularFile(current);
  return current;
}
function matchIdentity(job, agent) {
  for (const key of ['pane_id', 'terminal_id', 'workspace_id']) {
    requireValue(agent?.[key] === job[key], `Agent ${key} changed; reconcile before dispatch`);
  }
  requireValue(agent.agent === 'codex', 'Target is not Codex');
}
function matchAgent(job, agent) {
  matchIdentity(job, agent);
  requireValue(['idle', 'done'].includes(agent.agent_status), 'Agent is not ready for a new assignment');
  requireValue(fs.realpathSync(agent.cwd) === fs.realpathSync(job.cwd), 'Agent cwd differs from job');
}
function transport(args) {
  const result = spawnSync('herdr', args, {
    encoding: 'utf8', shell: false, windowsHide: true, timeout: 15000, maxBuffer: 1024 * 1024,
  });
  if (result.error || result.status !== 0) {
    throw new Error(result.error?.message || result.stderr || `Herdr exit ${result.status}`);
  }
  const parsed = JSON.parse(result.stdout);
  requireValue(parsed.result && !parsed.error, 'Herdr returned an error or missing result');
  return parsed;
}
function dispatch(directory, call = transport, env = process.env) {
  requireValue(env.HERDR_ENV === '1', 'Dispatch requires a Herdr-managed session');
  requireValue(env.HARNESS_ROLE !== 'worker', 'Workers cannot dispatch');
  requireValue(typeof env.HERDR_PANE_ID === 'string' && env.HERDR_PANE_ID, 'Missing caller pane');
  const job = loadJob(directory);
  const claimPath = path.join(directory, 'dispatch.json');
  requireValue(!fs.existsSync(claimPath), 'Dispatch already claimed; observe the existing attempt');
  requireValue(!fs.existsSync(job.receipt_file), 'Receipt already exists before dispatch');
  regularFile(job.prompt_file);
  regularFile(job.configuration_evidence);
  const prompt = fs.readFileSync(job.prompt_file, 'utf8');
  requireValue(prompt.trim().length > 0, 'Empty prompt');
  requireValue(fs.statSync(job.configuration_evidence).size > 0, 'Empty configuration evidence');
  const caller = call(['agent', 'get', env.HERDR_PANE_ID]).result.agent;
  const bale = call(['agent', 'get', 'bale']).result.agent;
  requireValue(caller?.pane_id === env.HERDR_PANE_ID &&
    caller.terminal_id && caller.terminal_id === bale?.terminal_id &&
    caller.pane_id === bale?.pane_id && caller.workspace_id === bale?.workspace_id,
  'Caller does not own the Bale alias');
  requireValue(job.terminal_id !== caller.terminal_id, 'Cannot dispatch to the coordinator');
  matchAgent(job, call(['agent', 'get', job.target]).result.agent);
  const context = job.context_files.map(file => { regularFile(file); return { path: file, sha256: digest(fs.readFileSync(file)) }; });
  requireValue(digest(fs.readFileSync(path.join(directory, 'job.json'))) === job.manifestHash,
    'Job changed during preflight');
  const claim = {
    schema_version: 2, manifest_sha256: job.manifestHash,
    configuration_sha256: digest(fs.readFileSync(job.configuration_evidence)), context,
    task_id: job.task_id, attempt_id: job.attempt_id,
    target: job.target, pane_id: job.pane_id, terminal_id: job.terminal_id,
    workspace_id: job.workspace_id, prompt_sha256: digest(prompt),
    claimed_at: new Date().toISOString(), state: 'delivery-uncertain',
  };
  // Exclusive creation is the at-most-once boundary, before any prompt input.
  const fd = fs.openSync(claimPath, 'wx');
  try { fs.writeFileSync(fd, JSON.stringify(claim, null, 2)); fs.fsyncSync(fd); }
  finally { fs.closeSync(fd); }
  try {
    const response = call(['agent', 'prompt', job.pane_id, prompt]);
    matchIdentity(job, response.result.agent);
    // Keep the claim immutable; a separate response file may be absent after a crash.
    fs.writeFileSync(path.join(directory, 'delivery.json'), JSON.stringify({
      at: new Date().toISOString(), state: 'submitted', response,
    }, null, 2), { flag: 'wx' });
    return { state: 'submitted', task_id: job.task_id, attempt_id: job.attempt_id };
  } catch (error) {
    fs.writeFileSync(path.join(directory, 'delivery-error.txt'), String(error), { flag: 'wx' });
    throw new Error(`Delivery uncertain; inspect the same handle. ${error.message}`);
  }
}
function inspectReceipt(directory) {
  const job = loadJob(directory);
  const claim = readJson(path.join(directory, 'dispatch.json'));
  requireValue(claim.schema_version === 2 && claim.manifest_sha256 === job.manifestHash,
    'Missing or changed immutable job manifest; reconcile the original attempt');
  requireValue(claim.configuration_sha256 === digest(fs.readFileSync(job.configuration_evidence)),
    'Configuration evidence changed after submission');
  requireValue(Array.isArray(claim.context) && claim.context.length === job.context_files.length,
    'Context snapshot missing');
  for (const [index, input] of claim.context.entries()) {
    requireValue(input.path === job.context_files[index] && input.sha256 === digest(fs.readFileSync(input.path)),
      'Context changed after submission');
  }
  for (const key of ['task_id', 'attempt_id', 'target', 'pane_id', 'terminal_id', 'workspace_id']) {
    requireValue(claim[key] === job[key], `Dispatch ${key} does not match job`);
  }
  requireValue(claim.prompt_sha256 === digest(fs.readFileSync(job.prompt_file, 'utf8')),
    'Packet changed after submission');
  regularFile(job.receipt_file);
  const receipt = readJson(job.receipt_file);
  for (const key of ['task_id', 'attempt_id']) {
    requireValue(receipt[key] === job[key], `Receipt ${key} mismatch`);
  }
  requireValue(receipt.status === 'completed', 'Worker has not reported completed');
  requireValue(typeof receipt.summary === 'string' && receipt.summary.trim(), 'Missing summary');
  requireValue(Array.isArray(receipt.outputs) &&
    new Set(receipt.outputs).size === receipt.outputs.length, 'Invalid output list');
  requireValue(receipt.outputs.length === job.expected_outputs.length &&
    job.expected_outputs.every(file => receipt.outputs.includes(file)), 'Unexpected or missing outputs');
  const artifacts = receipt.outputs.map(file => ({
    path: file, sha256: digest(fs.readFileSync(outputPath(job.cwd, file))),
  }));
  requireValue(Array.isArray(receipt.checks) && receipt.checks.length > 0 &&
    receipt.checks.every(check => typeof check.command === 'string' && check.command.trim() &&
      check.exit_code === 0), 'Missing or failed reported checks');
  return { state: 'receipt-inspected', task_id: job.task_id, attempt_id: job.attempt_id,
    artifacts, limitation: 'Identity/files/reported checks only. Bale must independently verify task semantics and allowed diff.' };
}
if (require.main === module) {
  try {
    const [command, directory, ...extra] = process.argv.slice(2);
    requireValue(!extra.length && ['dispatch', 'inspect-receipt'].includes(command),
      'Usage: submit-once.cjs dispatch|inspect-receipt ABSOLUTE_ATTEMPT_DIRECTORY');
    console.log(JSON.stringify(command === 'dispatch' ? dispatch(directory) : inspectReceipt(directory), null, 2));
  } catch (error) { console.error(error.message); process.exitCode = 1; }
}
module.exports = { dispatch, inspectReceipt, loadJob, matchAgent, outputPath };
