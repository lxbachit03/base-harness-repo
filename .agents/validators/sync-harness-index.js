#!/usr/bin/env node
/**
 * Cross-platform sync & check utility for docs-harness filesystem and INDEX.md.
 */

const fs = require('fs');
const path = require('path');

const CANONICAL_FOLDERS = [
  'harness-constraints',
  'decisions',
  'domain',
  'harness-improvements',
  'plans/active',
  'plans/completed',
  'tickets/active',
  'tickets/completed',
  'proposals',
  'risks',
];

const LINK_RE = /\[([^\]]+)\]\(([^)]+)\)/g;
const META_RE = /^(ID|TAG|PRIORITY|TITLE|CREATED|STATUS|REFERENCES):(?:\s*(.*))?$/;
const DOMAIN_FOLDER = 'domain';
const DOMAIN_FOLDER_RE = /^(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])-[a-z0-9]+(?:-[a-z0-9]+)*$/;

function parseResource(filePath, docsHarnessRoot, allowReadme = false) {
  const baseName = path.basename(filePath);
  if ((!allowReadme && baseName === 'README.md') || !filePath.endsWith('.md')) return null;

  let content;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (err) {
    return null;
  }

  const relPath = path.relative(docsHarnessRoot, filePath).replace(/\\/g, '/');
  const item = {
    path: filePath,
    relPath: relPath,
    resourceId: null,
    title: null,
    priority: null,
    created: null,
    status: null,
    references: [],
    tags: [],
  };

  const lines = content.split(/\r?\n/);
  let inReferences = false;
  for (const line of lines) {
    if (line.startsWith('## ')) break;
    const match = line.trim().match(META_RE);
    if (match) {
      const key = match[1];
      const val = (match[2] || '').trim();
      if (key === 'ID' && !item.resourceId) item.resourceId = val;
      else if (key === 'TITLE' && !item.title) item.title = val;
      else if (key === 'PRIORITY' && !item.priority) item.priority = val;
      else if (key === 'CREATED' && !item.created) item.created = val;
      else if (key === 'STATUS' && !item.status) item.status = val;
      else if (key === 'REFERENCES') {
        inReferences = true;
        if (val) item.references.push(val);
      }
      else if (key === 'TAG') item.tags.push(val);
      if (key !== 'REFERENCES') inReferences = false;
      continue;
    }
    if (inReferences && line.trim().startsWith('- ')) {
      item.references.push(line.trim().substring(2).trim());
    }
  }

  if (!item.title) {
    for (const line of lines) {
      if (line.startsWith('# ')) {
        item.title = line.substring(2).trim();
        break;
      }
    }
    if (!item.title) item.title = path.basename(filePath, '.md');
  }

  if (!item.priority) item.priority = '[NORMAL]';

  return item;
}

function discoverDomainResources(folder, docsHarnessRoot) {
  const items = [];
  const layoutErrors = [];
  const entries = fs.readdirSync(folder, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(folder, entry.name);
    if (entry.isDirectory()) {
      if (!DOMAIN_FOLDER_RE.test(entry.name)) {
        layoutErrors.push(`domain/${entry.name}: folder name must match <MMDD>-<lowercase-kebab-case-name>`);
      }
      const readmePath = path.join(fullPath, 'README.md');
      if (!fs.existsSync(readmePath) || !fs.statSync(readmePath).isFile()) {
        layoutErrors.push(`${path.relative(docsHarnessRoot, fullPath).replace(/\\/g, '/')}: README.md is required`);
        continue;
      }
      const item = parseResource(readmePath, docsHarnessRoot, true);
      if (item) {
        items.push(item);
        layoutErrors.push(...validateDomainResource(readmePath, item, docsHarnessRoot));
      }
      continue;
    }

    if (entry.isFile() && entry.name.endsWith('.md') && entry.name !== 'README.md') {
      const relPath = path.relative(docsHarnessRoot, fullPath).replace(/\\/g, '/');
      layoutErrors.push(`${relPath}: domain resources must use a date-prefixed folder with README.md`);
      const item = parseResource(fullPath, docsHarnessRoot);
      if (item) {
        items.push(item);
        layoutErrors.push(...validateDomainResource(fullPath, item, docsHarnessRoot));
      }
    }
  }

  return { items, layoutErrors };
}

function tagTokens(tags) {
  const tokens = [];
  for (const tag of tags) {
    const matches = [...tag.matchAll(/\[([^\]]+)\]/g)];
    if (matches.length > 0) matches.forEach((match) => tokens.push(match[1]));
    else if (tag) tokens.push(tag);
  }
  return [...new Set(tokens)];
}

function targetSectionsFor(item) {
  const tokens = tagTokens(item.tags);
  const sections = [];
  const domainState = tokens.find((token) => token === 'CONFIRMED' || token === 'UNCERTAIN');

  if (tokens.includes('DOMAIN') && domainState) {
    sections.push(`### [${domainState}]`);
  }

  for (const token of tokens) {
    if (token === 'CONFIRMED' || token === 'UNCERTAIN') continue;
    sections.push(`## TAG: [${token}]`);
  }

  const parts = item.relPath.split('/');
  if (parts.length > 1 && parts[0] !== DOMAIN_FOLDER) {
    sections.push(`### ${parts.slice(0, 2).join('/')}/`);
  }
  sections.push(`### ${parts[0]}/`);
  return [...new Set(sections)];
}

function validateDomainResource(filePath, item, docsHarnessRoot) {
  const errors = [];
  let content;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (err) {
    return [`${path.relative(docsHarnessRoot, filePath).replace(/\\/g, '/')}: cannot read README.md`];
  }

  const relPath = path.relative(docsHarnessRoot, filePath).replace(/\\/g, '/');
  const requiredMetadata = ['ID', 'TAG', 'PRIORITY', 'TITLE', 'CREATED', 'STATUS', 'REFERENCES'];
  for (const key of requiredMetadata) {
    if (!new RegExp(`^${key}:`, 'm').test(content)) {
      errors.push(`${relPath}: missing ${key} metadata`);
    }
  }

  const tokens = tagTokens(item.tags);
  if (!tokens.includes('DOMAIN')) errors.push(`${relPath}: TAG [DOMAIN] is required`);
  if (!tokens.includes('CONFIRMED') && !tokens.includes('UNCERTAIN')) {
    errors.push(`${relPath}: TAG [CONFIRMED] or TAG [UNCERTAIN] is required`);
  }
  if (!item.resourceId || item.resourceId.includes('<')) errors.push(`${relPath}: concrete ID is required`);
  if (!item.priority || item.priority.includes('<')) errors.push(`${relPath}: concrete PRIORITY is required`);
  if (!item.title || item.title.includes('<')) errors.push(`${relPath}: concrete TITLE is required`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(item.created || '')) errors.push(`${relPath}: CREATED must be YYYY-MM-DD`);
  if (!item.status || item.status.includes('<')) errors.push(`${relPath}: concrete STATUS is required`);
  if (item.references.length === 0 || item.references.some((reference) => !reference || reference.includes('<'))) {
    errors.push(`${relPath}: at least one concrete REFERENCES entry is required`);
  }

  for (const heading of ['Domain Statement', 'Evidence/Authority', 'Freshness', 'Confidence', 'Open Questions']) {
    if (!new RegExp(`^## ${heading}$`, 'm').test(content)) {
      errors.push(`${relPath}: missing ## ${heading} section`);
    }
  }

  const freshness = content.match(/^Freshness:\s*(CURRENT|STALE)\s*$/m);
  if (!freshness) {
    errors.push(`${relPath}: Freshness must be CURRENT or STALE`);
  } else if (freshness[1] === 'STALE' && item.status !== 'needs-review') {
    errors.push(`${relPath}: STALE freshness requires STATUS: needs-review`);
  } else if (item.status === 'needs-review' && freshness[1] !== 'STALE') {
    errors.push(`${relPath}: STATUS: needs-review requires Freshness: STALE`);
  }

  return errors;
}

function run() {
  const args = process.argv.slice(2);
  let rootDir = process.cwd();
  let isFix = false;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--fix') isFix = true;
    else if (args[i] === '--root' && args[i + 1]) {
      rootDir = path.resolve(args[i + 1]);
      i++;
    }
  }

  const docsHarness = path.join(rootDir, 'docs-harness');
  const indexPath = path.join(docsHarness, 'INDEX.md');

  if (!fs.existsSync(indexPath)) {
    console.error(`Error: INDEX.md not found at ${indexPath}`);
    process.exit(1);
  }

  const resources = new Map();
  const layoutErrors = [];
  for (const folderRel of CANONICAL_FOLDERS) {
    const folder = path.join(docsHarness, folderRel);
    if (!fs.existsSync(folder)) continue;
    if (folderRel === DOMAIN_FOLDER) {
      const discovered = discoverDomainResources(folder, docsHarness);
      discovered.items.forEach((item) => resources.set(item.relPath, item));
      layoutErrors.push(...discovered.layoutErrors);
      continue;
    }
    const entries = fs.readdirSync(folder);
    for (const entry of entries) {
      if (!entry.endsWith('.md') || entry === 'README.md') continue;
      const fullPath = path.join(folder, entry);
      const parsed = parseResource(fullPath, docsHarness);
      if (parsed) resources.set(parsed.relPath, parsed);
    }
  }

  let indexContent = fs.readFileSync(indexPath, 'utf8');
  const indexedLinks = new Set();
  let m;
  while ((m = LINK_RE.exec(indexContent)) !== null) {
    const target = m[2].trim().split('#')[0].split('?')[0];
    if (!target.startsWith('http://') && !target.startsWith('https://') && !target.startsWith('mailto:')) {
      indexedLinks.add(target);
    }
  }

  const missing = [];
  for (const [relPath, item] of resources.entries()) {
    if (!indexedLinks.has(relPath)) {
      missing.push(relPath);
    }
  }

  const stale = [];
  for (const target of indexedLinks) {
    const isCanonical = CANONICAL_FOLDERS.some((cf) => target === cf || target.startsWith(`${cf}/`));
    if (isCanonical && !fs.existsSync(path.join(docsHarness, target))) {
      stale.push(target);
    }
  }

  const duplicateIds = [];
  const seenIds = new Map();
  for (const item of resources.values()) {
    if (!item.resourceId) continue;
    if (seenIds.has(item.resourceId)) {
      duplicateIds.push(`${item.resourceId}: ${seenIds.get(item.resourceId)}, ${item.relPath}`);
    } else {
      seenIds.set(item.resourceId, item.relPath);
    }
  }

  if (isFix) {
    if (layoutErrors.length > 0 || duplicateIds.length > 0) {
      console.log('Synchronization check: FAILED');
      if (layoutErrors.length > 0) {
        console.log(`Invalid domain layout (${layoutErrors.length}):`);
        layoutErrors.forEach((error) => console.log(`  - ${error}`));
      }
      if (duplicateIds.length > 0) {
        console.log(`Duplicate resource IDs (${duplicateIds.length}):`);
        duplicateIds.forEach((duplicate) => console.log(`  - ${duplicate}`));
      }
      process.exit(1);
    }
    if (missing.length === 0 && stale.length === 0) {
      console.log('docs-harness/INDEX.md is already up-to-date.');
      process.exit(0);
    }

    let lines = indexContent.split(/\r?\n/);
    lines = lines.filter((line) => {
      let isStale = false;
      let match;
      const r = /\[([^\]]+)\]\(([^)]+)\)/g;
      while ((match = r.exec(line)) !== null) {
        if (stale.includes(match[2].trim())) isStale = true;
      }
      return !isStale;
    });

    for (const relPath of missing) {
      const item = resources.get(relPath);
      if (!item) continue;
      const idStr = item.resourceId ? `\`${item.resourceId}\`, ` : '';
      const entryLine = `- [${item.title}](${item.relPath}) — ${idStr}\`PRIORITY: ${item.priority}\``;

      let inserted = false;
      const targetSections = targetSectionsFor(item);

      for (const sec of targetSections) {
        for (let i = 0; i < lines.length; i++) {
          if (lines[i].trim() === sec) {
            for (let j = i + 1; j < Math.min(i + 30, lines.length); j++) {
              if (lines[j].trim() === 'Resources:') {
                let nextIdx = j + 1;
                while (nextIdx < lines.length && !lines[nextIdx].trim()) nextIdx++;
                if (nextIdx < lines.length && lines[nextIdx].includes('No ') && lines[nextIdx].includes('indexed yet')) {
                  lines[nextIdx] = entryLine;
                } else {
                  lines.splice(j + 2, 0, entryLine);
                }
                inserted = true;
                break;
              }
            }
            if (inserted) break;
          }
        }
        if (inserted) break;
      }
      if (!inserted) lines.push(entryLine);
    }

    fs.writeFileSync(indexPath, lines.join('\n') + '\n', 'utf8');
    console.log('Successfully synchronized and updated docs-harness/INDEX.md.');
    process.exit(0);
  } else {
    if (missing.length > 0 || stale.length > 0 || layoutErrors.length > 0 || duplicateIds.length > 0) {
      console.log('Synchronization check: FAILED');
      if (missing.length > 0) {
        console.log(`Missing from INDEX.md (${missing.length}):`);
        missing.forEach((m) => console.log(`  + ${m}`));
      }
      if (stale.length > 0) {
        console.log(`Stale links in INDEX.md (${stale.length}):`);
        stale.forEach((s) => console.log(`  - ${s}`));
      }
      if (layoutErrors.length > 0) {
        console.log(`Invalid domain layout (${layoutErrors.length}):`);
        layoutErrors.forEach((error) => console.log(`  - ${error}`));
      }
      if (duplicateIds.length > 0) {
        console.log(`Duplicate resource IDs (${duplicateIds.length}):`);
        duplicateIds.forEach((duplicate) => console.log(`  - ${duplicate}`));
      }
      console.log('\nRun with --fix to automatically synchronize docs-harness/INDEX.md.');
      process.exit(1);
    } else {
      console.log('Synchronization check: PASSED (docs-harness filesystem and INDEX.md are fully in sync).');
      process.exit(0);
    }
  }
}

run();
