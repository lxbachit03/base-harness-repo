const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const { analyze, planFix, readSnapshot, main } = require('./sync-harness-index.js');

const engine = path.join(__dirname, 'sync-harness-index.js');
const repo = path.resolve(__dirname, '../..');

function fixture() {
  return {
    directories: ['plans', 'plans/active', 'plans/completed', 'domain', 'risks', 'proposals', 'templates'],
    files: {
      'INDEX.md': '# Harness Index\n\n## Folder Tree\n\n```text\ndocs-harness/\n' +
        '├── plans/\n│   ├── active/\n│   └── completed/\n├── domain/\n├── risks/\n├── proposals/\n└── templates/\n```\n\n' +
        route('## Root Routing', './') +
        route('## TAG: [IMPROVE_HARNESS]', 'plans/') +
        route('### plans/active/', 'plans/active/') +
        route('### plans/completed/', 'plans/completed/') +
        route('## TAG: [DOMAIN]', 'domain/') +
        '### [CONFIRMED]\n\nResources:\n\n### [UNCERTAIN]\n\nResources:\n\n' +
        route('## TAG: [RISK]', 'risks/') +
        route('### proposals/', 'proposals/') +
        route('### templates/', 'templates/'),
    },
  };
}

function route(heading, folder) {
  return heading + '\n\nFolder: [' + folder + '](' + folder + ')\n\n' +
    'Purpose: test routing.\n\nRead when: relevant.\n\nSkip when: unrelated.\n\nResources:\n\n';
}

function resource(id, tags, title = 'Example', body = '## Evidence\n\nObserved.') {
  return '# Resource\n\nID: ' + id + '\n' + tags.map(t => 'TAG: [' + t + ']\n').join('') +
    'PRIORITY: [MEDIUM]\nTITLE: ' + title + '\nCREATED: 2026-09-06\nSTATUS: active\n' +
    'REFERENCES:\n- AGENTS.md\n\n' + body + '\n';
}

function addRoute(s, heading, rel, id, title = 'Example') {
  const start = s.files['INDEX.md'].indexOf(heading + '\n');
  assert.notEqual(start, -1);
  const marker = s.files['INDEX.md'].indexOf('Resources:', start) + 'Resources:'.length;
  const row = '\n\n- [' + title + '](' + rel + ') — `' + id + '`, `PRIORITY: [MEDIUM]`';
  s.files['INDEX.md'] = s.files['INDEX.md'].slice(0, marker) + row + s.files['INDEX.md'].slice(marker);
}

function planFixture() {
  const s = fixture(), rel = 'plans/active/0906-example.md', id = '#001_IMPROVE_HARNESS_0906';
  s.files[rel] = resource(id, ['IMPROVE_HARNESS']);
  addRoute(s, '## TAG: [IMPROVE_HARNESS]', rel, id);
  addRoute(s, '### plans/active/', rel, id);
  return s;
}

function domainFixture() {
  const s = fixture(), rel = 'domain/0906-example/README.md', id = '#001_DOMAIN_UNCERTAIN_0906';
  s.directories.push('domain/0906-example');
  s.files['INDEX.md'] = s.files['INDEX.md'].replace('├── domain/\n', '├── domain/\n│   └── 0906-example/\n');
  s.files[rel] = resource(id, ['DOMAIN', 'UNCERTAIN'], 'Example',
    '## Domain Statement\n\nObserved.\n\n## Evidence/Authority\n\nAGENTS.md\n\n' +
    '## Freshness\n\nFreshness: CURRENT\n\n## Confidence\n\nUncertain.\n\n## Open Questions\n\nNone.');
  addRoute(s, '### [UNCERTAIN]', rel, id);
  return s;
}

const risk = 'risks/0906-example.md', proposal = 'proposals/0906-example.md';
function pairFixture() {
  const s = fixture();
  const riskLink = '- [#001_RISK_0906 Risk](../risks/0906-example.md)';
  const proposalLink = '- [#002_RISK_0906 Proposal](../proposals/0906-example.md)';
  s.files[risk] = resource('#001_RISK_0906', ['RISK'], 'Risk',
    ['Risk', 'Evidence', 'Impact', 'Indicators', 'Mitigation', 'Verification', 'Related Proposals']
      .map(h => '## ' + h + '\n\n' + (h === 'Related Proposals' ? proposalLink : 'Observed.')).join('\n\n'))
    .replace('- AGENTS.md', proposalLink);
  s.files[proposal] = resource('#002_RISK_0906', ['RISK'], 'Proposal',
    ['Problem', 'Context', 'Related Risks', 'Options', 'Recommendation', 'Decision', 'Consequences', 'Residual Risk', 'Rollback']
      .map(h => '## ' + h + '\n\n' + (h === 'Related Risks' ? riskLink : 'Observed.')).join('\n\n'))
    .replace('- AGENTS.md', riskLink);
  addRoute(s, '## TAG: [RISK]', risk, '#001_RISK_0906', 'Risk');
  addRoute(s, '## TAG: [RISK]', proposal, '#002_RISK_0906', 'Proposal');
  addRoute(s, '### proposals/', proposal, '#002_RISK_0906', 'Proposal');
  return s;
}

function passes(s) { assert.deepEqual(analyze(s).errors, []); }
function fails(s, group, fragment = '') {
  const errors = analyze(s).errors;
  assert.ok(errors.some(e => e.group === group && e.message.includes(fragment)), JSON.stringify(errors));
}

test('real working Harness satisfies named checks without snapshot mutation', () => {
  const s = readSnapshot(repo), before = JSON.stringify(s);
  passes(s);
  assert.equal(JSON.stringify(s), before);
  assert.deepEqual(readSnapshot(repo), s);
});
test('empty canonical registry', () => passes(fixture()));
test('same canonical resource in two distinct valid routes', () => passes(planFixture()));
test('incomplete descendant tree is rejected', () => {
  const s = fixture(); s.directories.push('templates/nested');
  fails(s, 'tree', 'missing folder');
});
test('duplicate and stale tree paths are rejected', () => {
  const s = fixture(); s.files['INDEX.md'] = s.files['INDEX.md'].replace('└── templates/', '├── ghost/\n├── domain/\n└── templates/');
  fails(s, 'tree', 'duplicate'); fails(s, 'tree', 'stale folder');
});
test('duplicate Resources block is rejected', () => {
  const s = fixture(); s.files['INDEX.md'] = s.files['INDEX.md'].replace('Resources:', 'Resources:\n\nResources:');
  fails(s, 'sections', 'Resources:');
});
test('missing folder route metadata is rejected', () => {
  const s = fixture(); s.files['INDEX.md'] = s.files['INDEX.md'].replace('Read when: relevant.', 'Unrouted.');
  fails(s, 'sections', 'Read when:');
});
test('broken template link outside former canonical roots is rejected', () => {
  const s = fixture(); s.files['INDEX.md'] += '\n[Missing](templates/no-such-file.md)\n';
  fails(s, 'links', 'templates/no-such-file.md');
});
test('duplicate resource within the same route is rejected', () => {
  const s = planFixture(); addRoute(s, '### plans/active/', 'plans/active/0906-example.md', '#001_IMPROVE_HARNESS_0906');
  fails(s, 'routes', 'duplicate resource');
});
test('unclassified generic plan has lifecycle routing only', () => {
  const s = fixture(), rel = 'plans/active/0906-generic.md';
  s.files[rel] = resource('#001_PLAN_0906', []);
  addRoute(s, '### plans/active/', rel, '#001_PLAN_0906');
  passes(s);
});
test('global sequence reuse across different kinds is rejected', () => {
  const s = planFixture();
  s.files['plans/active/0906-second.md'] = resource('#001_PLAN_0906', []);
  fails(s, 'ids', 'reused sequence');
});
test('duplicate full ID is rejected', () => {
  const s = planFixture();
  s.files['plans/active/0906-second.md'] = s.files['plans/active/0906-example.md'];
  fails(s, 'ids', 'duplicate ID');
});
test('priority and duplicate metadata must be concrete and unique', () => {
  const s = planFixture();
  s.files['plans/active/0906-example.md'] = s.files['plans/active/0906-example.md'].replace(
    'PRIORITY: [MEDIUM]', 'PRIORITY: [URGENT]\nPRIORITY: [MEDIUM]');
  fails(s, 'metadata', 'PRIORITY'); fails(s, 'metadata', 'invalid priority');
});
test('real creation date must match immutable ID date', () => {
  const s = planFixture();
  s.files['plans/active/0906-example.md'] = s.files['plans/active/0906-example.md'].replace('2026-09-06', '2026-02-30');
  fails(s, 'metadata', 'invalid creation date');
});
test('nested domain README and legacy creation kind after confirmation', () => {
  const s = domainFixture(); passes(s);
  s.files['domain/0906-example/README.md'] = s.files['domain/0906-example/README.md'].replace('TAG: [UNCERTAIN]', 'TAG: [CONFIRMED]');
  s.files['INDEX.md'] = s.files['INDEX.md'].replace(
    '### [UNCERTAIN]\n\nResources:\n\n- [Example]', '### [UNCERTAIN]\n\nResources:\n\n');
  // Rebuild only the two state routes to move the one entry deliberately.
  s.files['INDEX.md'] = s.files['INDEX.md'].replace(/\(domain\/0906-example\/README.md\).*\n/, '');
  addRoute(s, '### [CONFIRMED]', 'domain/0906-example/README.md', '#001_DOMAIN_UNCERTAIN_0906');
  passes(s);
});
test('domain cannot have both confirmation tags', () => {
  const s = domainFixture(); s.files['domain/0906-example/README.md'] += '\n';
  s.files['domain/0906-example/README.md'] = s.files['domain/0906-example/README.md'].replace('TAG: [UNCERTAIN]', 'TAG: [UNCERTAIN]\nTAG: [CONFIRMED]');
  fails(s, 'domain', 'exactly one');
});
test('domain missing canonical README and stale/current mismatches fail', () => {
  const s = domainFixture(); s.files['domain/0906-example/README.md'] = s.files['domain/0906-example/README.md'].replace('Freshness: CURRENT', 'Freshness: STALE');
  fails(s, 'domain', 'freshness/status');
  delete s.files['domain/0906-example/README.md'];
  fails(s, 'domain', 'README.md missing');
});
test('domain routed under incorrect state is rejected', () => {
  const s = domainFixture();
  addRoute(s, '### [CONFIRMED]', 'domain/0906-example/README.md', '#001_DOMAIN_UNCERTAIN_0906');
  fails(s, 'routes', 'wrong classification');
});
test('supporting artifacts and nested ordinary tickets are not canonical resources', () => {
  const s = fixture();
  s.files['tickets/active/TBD-example/ticket.md'] = '---\nstatus: intake\n---\n# Ticket\n';
  s.files['domain/0906-example/schemas/example.md'] = '# Supporting evidence\n';
  passes(s);
});
test('valid reciprocal risk/proposal pair and shared proposal', () => {
  const s = pairFixture(); passes(s);
  s.files['risks/0906-second.md'] = s.files[risk].replace('#001_RISK_0906', '#003_RISK_0906').replace('TITLE: Risk', 'TITLE: Second');
  const link = '- [#003_RISK_0906 Second](../risks/0906-second.md)';
  s.files[proposal] = s.files[proposal].replaceAll('- [#001_RISK_0906 Risk](../risks/0906-example.md)',
    '- [#001_RISK_0906 Risk](../risks/0906-example.md)\n' + link);
  addRoute(s, '## TAG: [RISK]', 'risks/0906-second.md', '#003_RISK_0906', 'Second');
  passes(s);
});
test('risk missing counterpart and one-sided references are rejected', () => {
  const s = pairFixture(); delete s.files[proposal];
  fails(s, 'risk-links', 'missing counterpart');
  const p = pairFixture(); p.files[proposal] = p.files[proposal].replace('REFERENCES:\n- [#001_RISK_0906 Risk](../risks/0906-example.md)', 'REFERENCES:');
  fails(p, 'risk-links', 'one-sided');
});
test('orphan proposal, unresolved paths, related-set mismatch, required sections', () => {
  const s = pairFixture(); s.files[risk] = s.files[risk].replaceAll('../proposals/0906-example.md', '../proposals/0906-missing.md');
  fails(s, 'risk-links', 'invalid counterpart');
  const p = pairFixture(); p.files[proposal] = p.files[proposal].replace('## Related Risks', '## Missing');
  fails(p, 'risk-links', 'counterparts differ'); fails(p, 'risk-links', 'missing section');
});
test('risk routing omission is rejected without requiring nested-only grammar', () => {
  const s = pairFixture();
  s.files['INDEX.md'] = s.files['INDEX.md'].replaceAll(/^- \[Proposal\].*\n/gm, '');
  fails(s, 'routes', 'missing from');
});
test('risk labels and canonical counterpart paths remain verifiable', () => {
  const s = pairFixture();
  s.files[risk] = s.files[risk].replaceAll('#002_RISK_0906 Proposal', '#999_RISK_0906 Wrong');
  fails(s, 'risk-links', 'label ID/title mismatch');
  const p = pairFixture();
  p.files[risk] = p.files[risk].replaceAll('../proposals/0906-example.md', '../proposals/0906-example.md#fragment');
  fails(p, 'risk-links', 'canonical relative path');
});
test('fix plans tree and all missing routes without mutating snapshot', () => {
  const s = fixture();
  s.files['plans/active/0906-example.md'] = resource('#001_IMPROVE_HARNESS_0906', ['IMPROVE_HARNESS']);
  s.directories.push('templates/nested');
  const before = JSON.stringify(s), result = planFix(s);
  assert.deepEqual(result.errors, []);
  assert.match(result.index, /nested\//);
  assert.equal((result.index.match(/\]\(plans\/active\/0906-example.md\)/g) || []).length, 2);
  assert.equal(JSON.stringify(s), before);
  assert.equal(planFix({ ...s, files: { ...s.files, 'INDEX.md': result.index } }).index, result.index);
});
test('fix refuses ambiguity without silently deleting a prose line', () => {
  const s = fixture(); s.files['INDEX.md'] += '\nImportant [missing](templates/gone.md) policy.\n';
  const result = planFix(s);
  assert.ok(result.errors.length);
  assert.equal(result.index, undefined);
});
test('symlink scope errors and unknown flags fail explicitly', () => {
  const s = fixture(); s.errors = ['symlink is outside validator scope'];
  fails(s, 'scope', 'symlink');
  assert.equal(spawnSync(process.execPath, [engine, '--bogus'], { encoding: 'utf8' }).status, 2);
});

function materialize(t, s) {
  const tempParent = fs.realpathSync(os.tmpdir());
  const root = fs.mkdtempSync(path.join(tempParent, 'harness-validator-test-'));
  const resolved = fs.realpathSync(root);
  assert.equal(path.dirname(resolved), tempParent);
  assert.ok(path.basename(resolved).startsWith('harness-validator-test-'));
  t.after(() => {
    const target = fs.realpathSync(root);
    assert.equal(target, resolved);
    assert.equal(path.dirname(target), tempParent);
    assert.ok(path.basename(target).startsWith('harness-validator-test-'));
    fs.rmSync(target, { recursive: true });
  });
  for (const dir of s.directories) fs.mkdirSync(path.join(root, 'docs-harness', dir), { recursive: true });
  for (const [rel, content] of Object.entries(s.files)) {
    const target = path.join(root, 'docs-harness', rel);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.writeFileSync(target, content);
  }
  return root;
}

test('CLI check is read-only; invalid fix writes nothing; safe fix is idempotent', t => {
  const s = fixture(); s.directories.push('templates/nested');
  const root = materialize(t, s), index = path.join(root, 'docs-harness/INDEX.md');
  const before = fs.readFileSync(index, 'utf8');
  const cli = (...args) => spawnSync(process.execPath, [engine, '--root', root, ...args], { encoding: 'utf8' });
  assert.equal(cli('--check').status, 1);
  assert.equal(fs.readFileSync(index, 'utf8'), before);
  assert.equal(cli('--fix').status, 0);
  const fixed = fs.readFileSync(index, 'utf8');
  assert.notEqual(fixed, before);
  assert.equal(cli('--fix').status, 0);
  assert.equal(fs.readFileSync(index, 'utf8'), fixed);
  fs.appendFileSync(index, '\n[broken](templates/missing.md)\n');
  const invalid = fs.readFileSync(index, 'utf8');
  assert.equal(cli('--fix').status, 1);
  assert.equal(fs.readFileSync(index, 'utf8'), invalid);
});

test('concurrent content drift returns tooling failure and preserves the changed file', t => {
  const root = materialize(t, fixture());
  const index = path.join(root, 'docs-harness/INDEX.md');
  const originalRead = fs.readFileSync;
  let changed = false;
  const messages = [];
  t.mock.method(console, 'error', message => messages.push(message));
  t.mock.method(fs, 'readFileSync', function (target, ...args) {
    const bytes = originalRead.call(fs, target, ...args);
    if (!changed && path.resolve(String(target)) === index) {
      changed = true;
      fs.appendFileSync(index, '\nConcurrent owner note.\n');
    }
    return bytes;
  });
  assert.equal(main(['--root', root, '--check']), 2);
  assert.ok(messages.some(message => message.includes('Scope changed')));
  assert.match(originalRead(index, 'utf8'), /Concurrent owner note/);
});
