#!/usr/bin/env node
'use strict';
// Canonical structural validator. Pure analysis/fix planning is exported for tests.
const fs = require('node:fs');
const path = require('node:path');
const { createHash } = require('node:crypto');
const { TextDecoder } = require('node:util');

const RESOURCE_ROOTS = ['harness-constraints', 'decisions', 'domain',
  'harness-improvements', 'plans', 'proposals', 'risks'];
const PRIORITIES = ['[CRITIAL]', '[MEDIUM]', '[NORMAL]'];
const TAGS = ['IMPROVE_HARNESS', 'CONSTRAINTS', 'RISK', 'DOMAIN', 'CONFIRMED', 'UNCERTAIN'];
const ID_RE = /^#([0-9]{3,})_([A-Z_]+)_([0-9]{4})$/;
const LINKS = /\[([^\]]+)\]\(([^)]+)\)/g;

function prose(text) {
  let fenced = false;
  return text.replace(/\r\n/g, '\n').split('\n').map(line => {
    if (/^\s*```/.test(line)) { fenced = !fenced; return ''; }
    return fenced ? '' : line;
  }).join('\n');
}

function links(text) {
  return [...text.matchAll(LINKS)].map(m => ({ label: m[1], raw: m[2].trim(),
    target: m[2].trim().split(/[?#]/)[0] }));
}

function local(link) {
  return link.target && !/^[a-z][a-z0-9+.-]*:/i.test(link.raw);
}

function clean(target) { return path.posix.normalize(target).replace(/^\.\//, '').replace(/\/$/, '') || '.'; }

function sections(text) {
  const lines = prose(text).split('\n'), result = [];
  for (let i = 0; i < lines.length; i++) {
    const match = lines[i].match(/^(#{2,3}) (.+)$/);
    if (!match) continue;
    let end = i + 1;
    while (end < lines.length && !/^#{2,3} /.test(lines[end])) end++;
    result.push({ heading: lines[i], title: match[2], start: i, end,
      body: lines.slice(i + 1, end).join('\n') });
  }
  return result;
}

function metadata(text) {
  const head = prose(text).split(/^## /m)[0], values = {};
  for (const match of head.matchAll(/^(ID|TAG|PRIORITY|TITLE|CREATED|STATUS|REFERENCES):[ \t]*(.*)$/gm)) {
    (values[match[1]] ||= []).push(match[2].trim());
  }
  const get = key => (values[key] || [])[0];
  return { values, id: get('ID'), priority: get('PRIORITY'), title: get('TITLE'),
    created: get('CREATED'), status: get('STATUS'),
    tags: [...(values.TAG || []).join(' ').matchAll(/\[([^\]]+)\]/g)].map(m => m[1]) };
}

function requiredRoutes(rel, item) {
  const routes = item.tags.filter(t => !['DOMAIN', 'CONFIRMED', 'UNCERTAIN'].includes(t))
    .map(t => '## TAG: [' + t + ']');
  if (item.tags.includes('DOMAIN')) {
    for (const state of ['CONFIRMED', 'UNCERTAIN']) {
      if (item.tags.includes(state)) routes.push('### [' + state + ']');
    }
  }
  if (rel.startsWith('plans/')) routes.push('### ' + rel.split('/').slice(0, 2).join('/') + '/');
  else if (['decisions', 'proposals'].includes(rel.split('/')[0]))
    routes.push('### ' + rel.split('/')[0] + '/');
  return [...new Set(routes)];
}

function treeText(directories) {
  const lines = ['docs-harness/'];
  const append = (parent, prefix) => {
    const children = directories.filter(d => path.posix.dirname(d) === (parent || '.')).sort();
    children.forEach((child, i) => {
      const last = i === children.length - 1;
      lines.push(prefix + (last ? '└── ' : '├── ') + path.posix.basename(child) + '/');
      append(child, prefix + (last ? '    ' : '│   '));
    });
  };
  append('', '');
  return lines.join('\n');
}

function parseTree(index) {
  const block = index.match(/## Folder Tree\s+\x60\x60\x60text\n([\s\S]*?)\n\x60\x60\x60/);
  if (!block) return { paths: [], errors: ['Folder Tree text block is missing'] };
  const lines = block[1].split('\n'), stack = [], paths = [], errors = [];
  if (lines.shift() !== 'docs-harness/') errors.push('tree root must be docs-harness/');
  for (const line of lines) {
    const m = line.match(/^((?:│   |    )*)(?:├── |└── )([^/]+)\/$/);
    if (!m) { errors.push('invalid tree row: ' + line); continue; }
    const depth = m[1].length / 4;
    if (depth > stack.length) { errors.push('invalid indentation: ' + line); continue; }
    stack.length = depth;
    stack.push(m[2]);
    paths.push(stack.join('/'));
  }
  if (new Set(paths).size !== paths.length) errors.push('duplicate folder in tree');
  return { paths, errors };
}

function sectionBody(text, heading) {
  // Relationship blocks are literal lists: fences/subheadings cannot hide entries.
  const lines = text.replace(/\r\n/g, '\n').split('\n');
  const start = lines.findIndex(line => line === heading);
  if (start < 0) return '';
  let end = start + 1;
  while (end < lines.length && !lines[end].startsWith('## ')) end++;
  return lines.slice(start + 1, end).join('\n');
}

function referenceBody(text, literal = false) {
  const head = (literal ? text.replace(/\r\n/g, '\n') : prose(text)).split(/^## /m)[0];
  const match = head.match(/^REFERENCES:[ \t]*(.*)\n?([\s\S]*)$/m);
  return match ? (match[1].trim() ? '- ' + match[1].trim() + '\n' : '') + match[2] : '';
}

function referenceTargets(text, rel, resources, report = () => {}) {
  const targets = new Set();
  for (const line of text.split('\n').filter(l => l.trim())) {
    const bullet = line.match(/^- (.+)$/);
    if (!bullet) { report('malformed counterpart entry: ' + line); continue; }
    const entry = bullet[1].trim(), markdown = entry.match(/^\[([^\]]+)\]\(([^)]+)\)$/);
    const token = (markdown ? markdown[2].trim() : entry.replace(/^`([^`]+)`$/, '$1'));
    let target;
    if (ID_RE.test(token)) {
      const found = [...resources].find(([, r]) => r.id === token);
      target = found ? found[0] : token;
    } else {
      if (/[?#\\\s<>\[\]()`]/.test(token) || /^(?:\/|~|[a-z][a-z0-9+.-]*:)/i.test(token)) {
        report('counterpart must use a canonical relative path or immutable ID: ' + entry);
        continue;
      }
      target = token.startsWith('docs-harness/') ? token.slice(13) :
        clean(path.posix.join(path.posix.dirname(rel), token));
    }
    const peer = resources.get(target);
    if (markdown && peer && markdown[1] !== peer.id + ' ' + peer.title)
      report('counterpart label ID/title mismatch');
    if (targets.has(target)) report('duplicate counterpart: ' + target);
    targets.add(target);
  }
  return targets;
}

function analyze(snapshot, { riskOnly = false } = {}) {
  const errors = [], resources = new Map(), index = snapshot.files['INDEX.md'];
  const fail = (group, message) => errors.push({ group, message });
  for (const problem of snapshot.errors || []) fail('scope', problem);
  if (typeof index !== 'string') return { errors: [...errors, { group: 'scope', message: 'INDEX.md is missing' }], resources };
  for (const kind of ['risks', 'proposals']) {
    if (!snapshot.directories.includes(kind)) fail('scope', kind + ': required directory missing');
    for (const dir of snapshot.directories.filter(d => d.startsWith(kind + '/')))
      fail('scope', dir + ': nested risk/proposal directory is not allowed');
    for (const rel of Object.keys(snapshot.files).filter(p => p.startsWith(kind + '/'))) {
      if (!rel.endsWith('.md')) fail('scope', rel + ': non-Markdown risk/proposal file is not allowed');
      if (rel.split('/').length !== 2) fail('scope', rel + ': nested risk/proposal file is not allowed');
    }
  }
  const indexProse = prose(index), routeSections = sections(index);
  for (const [rel, text] of Object.entries(snapshot.files)) {
    if (rel.startsWith('templates/') || !rel.endsWith('.md')) continue;
    const item = metadata(text);
    const canonicalFile = RESOURCE_ROOTS.includes(rel.split('/')[0]) &&
      path.posix.basename(rel) !== 'README.md';
    const domainRoot = /^domain\/[^/]+\/README\.md$/.test(rel);
    if (!item.id && !canonicalFile && !domainRoot) continue;
    // Supporting files without an ID are owned by their domain/ticket README.
    if (!item.id && !domainRoot && rel.split('/').length > (rel.startsWith('plans/') ? 3 : 2)) continue;
    resources.set(rel, item);
    const idMatch = (item.id || '').match(ID_RE);
    if (!idMatch) fail('metadata', rel + ': invalid or missing ID');
    for (const key of ['ID', 'PRIORITY', 'TITLE', 'CREATED', 'STATUS', 'REFERENCES']) {
      if ((item.values[key] || []).length !== 1) fail('metadata', rel + ': expected exactly one ' + key);
      if (key !== 'REFERENCES' && (!item.values[key]?.[0] || /[<>]/.test(item.values[key][0])))
        fail('metadata', rel + ': concrete ' + key + ' required');
    }
    if (!PRIORITIES.includes(item.priority)) fail('metadata', rel + ': invalid priority');
    if (!/^\d{4}-\d{2}-\d{2}$/.test(item.created || '') ||
      Number.isNaN(Date.parse(item.created)) ||
      new Date(item.created).toISOString().slice(0, 10) !== item.created) {
      fail('metadata', rel + ': invalid creation date');
    } else if (idMatch && idMatch[3] !== item.created.slice(5).replace('-', ''))
      fail('metadata', rel + ': ID date differs from CREATED');
    if (item.tags.some(t => !TAGS.includes(t)) || new Set(item.tags).size !== item.tags.length)
      fail('metadata', rel + ': invalid or duplicate TAG');
    const domain = rel.startsWith('domain/');
    if (!item.tags.length && !/^(plans|decisions)\//.test(rel))
      fail('metadata', rel + ': classification TAG required');
    const expectedTag = { risks: 'RISK', 'harness-constraints': 'CONSTRAINTS',
      'harness-improvements': 'IMPROVE_HARNESS' }[rel.split('/')[0]];
    if (expectedTag && !item.tags.includes(expectedTag))
      fail('metadata', rel + ': missing folder classification ' + expectedTag);
    const name = domainRoot ? rel.split('/')[1] : path.posix.basename(rel, '.md');
    if (!/^\d{4}-[a-z0-9]+(?:-[a-z0-9]+)*$/.test(name) ||
      (idMatch && !name.startsWith(idMatch[3] + '-')))
      fail('metadata', rel + ': filename/folder must use immutable MMDD and kebab-case');
    if (domain) {
      const states = item.tags.filter(t => ['CONFIRMED', 'UNCERTAIN'].includes(t));
      if (!item.tags.includes('DOMAIN') || states.length !== 1)
        fail('domain', rel + ': exactly one DOMAIN confirmation state required');
      if (rel.split('/').length === 2)
        fail('domain', rel + ': use a date-prefixed folder/README.md');
      for (const heading of ['Domain Statement', 'Evidence/Authority', 'Freshness', 'Confidence', 'Open Questions']) {
        if (!sections(text).some(s => s.heading === '## ' + heading))
          fail('domain', rel + ': missing section ' + heading);
      }
      const freshness = [...prose(text).matchAll(/^Freshness:[ \t]*(CURRENT|STALE)[ \t]*$/gm)];
      if (freshness.length !== 1 || (freshness[0][1] === 'STALE') !== (item.status === 'needs-review'))
        fail('domain', rel + ': invalid freshness/status pair');
      const refs = referenceBody(text);
      if (!/^\s*- \S/m.test(refs) || /^\s*- .*</m.test(refs))
        fail('domain', rel + ': concrete evidence reference required');
    }
  }
  const ids = new Map(), sequences = new Map();
  for (const [rel, item] of resources) {
    if (ids.has(item.id)) fail('ids', 'duplicate ID: ' + item.id + ' at ' + ids.get(item.id) + ', ' + rel);
    ids.set(item.id, rel);
    const match = (item.id || '').match(ID_RE);
    if (match) {
      const seq = Number(match[1]);
      if (sequences.has(seq)) fail('ids', 'reused sequence ' + seq + ': ' + sequences.get(seq) + ', ' + rel);
      sequences.set(seq, rel);
    }
  }
  for (const folder of snapshot.directories.filter(d => /^domain\/[^/]+$/.test(d))) {
    if (!/^domain\/\d{4}-[a-z0-9]+(?:-[a-z0-9]+)*$/.test(folder))
      fail('domain', folder + ': invalid canonical folder');
    if (!Object.hasOwn(snapshot.files, folder + '/README.md'))
      fail('domain', folder + ': canonical README.md missing');
  }

  // Risk/proposal reciprocity is mechanical; this does not assess mitigation quality.
  for (const [rel] of resources) {
    const kind = rel.split('/')[0];
    if (!['risks', 'proposals'].includes(kind)) continue;
    const other = kind === 'risks' ? 'proposals' : 'risks';
    const required = kind === 'risks'
      ? ['Risk', 'Evidence', 'Impact', 'Indicators', 'Mitigation', 'Verification', 'Related Proposals']
      : ['Problem', 'Context', 'Related Risks', 'Options', 'Recommendation', 'Decision', 'Consequences', 'Residual Risk', 'Rollback'];
    for (const heading of required)
      if (!sections(snapshot.files[rel]).some(section => section.heading === '## ' + heading))
        fail('risk-links', rel + ': missing section ' + heading);
    const report = message => fail('risk-links', rel + ': ' + message);
    const refs = referenceTargets(referenceBody(snapshot.files[rel], true), rel, resources, report);
    const related = referenceTargets(sectionBody(snapshot.files[rel],
      kind === 'risks' ? '## Related Proposals' : '## Related Risks'), rel, resources, report);
    for (const target of [...refs, ...related])
      if (!target.startsWith(other + '/') || !resources.has(target))
        fail('risk-links', rel + ': invalid counterpart path/ID ' + target);
    const peers = new Set([...refs].filter(p => p.startsWith(other + '/') || ID_RE.test(p)));
    if (!peers.size) fail('risk-links', rel + ': counterpart reference required');
    const relatedPeers = new Set([...related].filter(p => p.startsWith(other + '/') || ID_RE.test(p)));
    if ([...peers].sort().join('|') !== [...relatedPeers].sort().join('|'))
      fail('risk-links', rel + ': REFERENCES and related counterparts differ');
    for (const peer of peers) {
      if (!resources.has(peer)) { fail('risk-links', rel + ': missing counterpart ' + peer); continue; }
      const back = referenceTargets(referenceBody(snapshot.files[peer], true), peer, resources);
      if (!back.has(rel)) fail('risk-links', rel + ': one-sided counterpart ' + peer);
    }
  }

  if (!riskOnly) {
    const parsedTree = parseTree(index);
    parsedTree.errors.forEach(e => fail('tree', e));
    for (const d of snapshot.directories) if (!parsedTree.paths.includes(d)) fail('tree', 'missing folder: ' + d);
    for (const d of parsedTree.paths) if (!snapshot.directories.includes(d)) fail('tree', 'stale folder: ' + d);
    const seenHeadings = new Set();
    for (const section of routeSections) {
      if (seenHeadings.has(section.heading)) fail('sections', 'duplicate heading: ' + section.heading);
      seenHeadings.add(section.heading);
      if (/^Folder:/m.test(section.body)) {
        for (const marker of ['Folder:', 'Purpose:', 'Read when:', 'Skip when:', 'Resources:']) {
          if (section.body.split('\n').filter(l => l.startsWith(marker)).length !== 1)
            fail('sections', section.heading + ': expected one ' + marker);
        }
      }
      if (/^### \[(CONFIRMED|UNCERTAIN)\]$/.test(section.heading) &&
        section.body.split('\n').filter(l => l === 'Resources:').length !== 1)
        fail('sections', section.heading + ': expected one Resources:');
      const resourceLinks = links(section.body).filter(l => resources.has(clean(l.target)));
      const seen = new Set();
      for (const link of resourceLinks) {
        const target = clean(link.target);
        if (seen.has(target)) fail('routes', section.heading + ': duplicate resource ' + target);
        seen.add(target);
        const item = resources.get(target);
        const row = section.body.split('\n').find(l => l.includes('](' + link.raw + ')')) || '';
        if (!row.includes(item.id) || !row.includes('PRIORITY: ' + item.priority))
          fail('routes', target + ': route ID/priority mismatch');
        if (!requiredRoutes(target, item).includes(section.heading))
          fail('routes', target + ': wrong classification/lifecycle section ' + section.heading);
      }
    }
    const folderRoutes = new Set(routeSections.flatMap(section => {
      const match = section.body.match(/^Folder: (.+)$/m);
      return match ? links(match[1]).map(l => clean(l.target)) : [];
    }));
    for (const folder of snapshot.directories.filter(d => !d.includes('/') || /^(plans|tickets)\/(active|completed)$/.test(d)))
      if (!folderRoutes.has(folder)) fail('sections', 'missing folder route: ' + folder);
    for (const link of links(indexProse).filter(local)) {
      const target = clean(link.target);
      const exists = target === '.' || snapshot.directories.includes(target) ||
        Object.hasOwn(snapshot.files, target) || (snapshot.externalPaths || []).includes(target);
      if (!exists) fail('links', 'unresolved INDEX target: ' + link.raw);
    }
    for (const [rel, item] of resources) {
      for (const heading of requiredRoutes(rel, item)) {
        const section = routeSections.find(s => s.heading === heading);
        if (!section) fail('sections', rel + ': missing route section ' + heading);
        else if (!links(section.body).some(l => clean(l.target) === rel))
          fail('routes', rel + ': missing from ' + heading);
      }
    }
  }
  return { errors, resources };
}

function planFix(snapshot) {
  let next = snapshot.files['INDEX.md'];
  if (typeof next !== 'string') return { errors: [{ group: 'scope', message: 'INDEX.md is missing' }] };
  const initial = analyze(snapshot);
  // Only reconstruct factual tree and add resource entries to existing routes.
  // Ambiguous metadata, headings, stale links, and duplicates require manual repair.
  if (initial.errors.some(e => !['tree', 'routes'].includes(e.group) ||
    (e.group === 'routes' && !e.message.includes(': missing from ')))) return initial;
  next = next.replace(/(## Folder Tree\s+\x60\x60\x60text\n)[\s\S]*?(\n\x60\x60\x60)/,
    (_, start, end) => start + treeText(snapshot.directories) + end);
  for (const [rel, item] of initial.resources) {
    for (const heading of requiredRoutes(rel, item)) {
      const section = sections(next).find(s => s.heading === heading);
      if (!section || links(section.body).some(l => clean(l.target) === rel)) continue;
      const lines = next.split('\n');
      let pos = section.start + 1;
      while (pos < section.end && lines[pos] !== 'Resources:') pos++;
      if (pos === section.end) return { errors: [{ group: 'sections', message: heading + ': Resources block missing' }] };
      lines.splice(pos + 1, 0, '', '- [' + item.title + '](' + rel + ') — `' + item.id +
        '`, `PRIORITY: ' + item.priority + '`');
      next = lines.join('\n');
    }
  }
  const checked = analyze({ ...snapshot, files: { ...snapshot.files, 'INDEX.md': next } });
  return { ...checked, index: next };
}

function readSnapshot(root) {
  const base = path.join(root, 'docs-harness'), files = {}, directories = [], errors = [], hashes = {};
  if (!fs.existsSync(base) || fs.lstatSync(base).isSymbolicLink() || !fs.lstatSync(base).isDirectory())
    return { files, directories, errors: ['docs-harness must be an existing real directory'] };
  const walk = (folder, rel) => {
    for (const entry of fs.readdirSync(folder, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
      const name = rel ? rel + '/' + entry.name : entry.name, absolute = path.join(folder, entry.name);
      if (entry.isSymbolicLink()) { errors.push('symlink is outside validator scope: ' + name); continue; }
      if (entry.isDirectory()) { directories.push(name); walk(absolute, name); }
      else if (entry.isFile()) {
        const bytes = fs.readFileSync(absolute);
        hashes[name] = createHash('sha256').update(bytes).digest('hex');
        if (entry.name.endsWith('.md')) {
          try { files[name] = new TextDecoder('utf-8', { fatal: true, ignoreBOM: true }).decode(bytes).replace(/\r\n/g, '\n'); }
          catch { throw new Error(name + ': invalid UTF-8'); }
        } else files[name] = '';
      } else errors.push('non-regular entry is outside validator scope: ' + name);
    }
  };
  walk(base, '');
  const externalPaths = links(prose(files['INDEX.md'] || '')).filter(local)
    .map(l => clean(l.target)).filter(t => t.startsWith('../') && fs.existsSync(path.resolve(base, t)));
  return { files, directories, externalPaths, errors, hashes };
}

function main(args = process.argv.slice(2)) {
  let root = process.cwd(), fix = false, check = false, riskOnly = false;
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--root' && args[i + 1] && !args[i + 1].startsWith('--')) root = path.resolve(args[++i]);
    else if (args[i] === '--fix') fix = true;
    else if (args[i] === '--check') check = true;
    else if (args[i] === '--risk-links') riskOnly = true;
    else { console.error('Usage: sync-harness-index.js [--root PATH] [--check | --fix] [--risk-links]'); return 2; }
  }
  if (fix && (check || riskOnly)) { console.error('--fix cannot be combined with --check or --risk-links'); return 2; }
  try {
    const snapshot = readSnapshot(root), result = fix ? planFix(snapshot) : analyze(snapshot, { riskOnly });
    if (JSON.stringify(readSnapshot(root)) !== JSON.stringify(snapshot)) {
      console.error('Scope changed during validation; no files written.');
      return 2;
    }
    if (result.errors.length) {
      for (const error of result.errors) console.error('FAIL|' + error.group + '|' + error.message);
      console.error('Structural check: FAILED; no files written.');
      return 1;
    }
    if (fix && result.index !== snapshot.files['INDEX.md']) {
      if (JSON.stringify(readSnapshot(root)) !== JSON.stringify(snapshot)) {
        console.error('Scope changed while planning the fix; no files written.');
        return 2;
      }
      fs.writeFileSync(path.join(root, 'docs-harness', 'INDEX.md'), result.index, 'utf8');
      console.log('Updated INDEX.md tree and missing canonical route entries.');
    }
    const groups = riskOnly ? 'metadata, ids, domain, risk-links' :
      'tree, sections, links, routes, metadata, ids, domain, risk-links';
    console.log('Structural check: PASSED (' + groups + ').');
    console.log('Not checked: source-claim truth, external URLs, runtime behavior, agent effectiveness.');
    return 0;
  } catch (error) {
    console.error('Validator unavailable: ' + error.message);
    return 2;
  }
}

module.exports = { analyze, planFix, readSnapshot, treeText, requiredRoutes, main };
if (require.main === module) process.exitCode = main();
