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

function parseResource(filePath, docsHarnessRoot) {
  const baseName = path.basename(filePath);
  if (baseName === 'README.md' || !filePath.endsWith('.md')) return null;

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
    tags: [],
  };

  const lines = content.split(/\r?\n/);
  for (const line of lines) {
    if (line.startsWith('## ')) break;
    const match = line.trim().match(META_RE);
    if (match) {
      const key = match[1];
      const val = (match[2] || '').trim();
      if (key === 'ID' && !item.resourceId) item.resourceId = val;
      else if (key === 'TITLE' && !item.title) item.title = val;
      else if (key === 'PRIORITY' && !item.priority) item.priority = val;
      else if (key === 'TAG') item.tags.push(val);
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
  for (const folderRel of CANONICAL_FOLDERS) {
    const folder = path.join(docsHarness, folderRel);
    if (!fs.existsSync(folder)) continue;
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
    const isCanonical = CANONICAL_FOLDERS.some((cf) => target.startsWith(cf));
    if (isCanonical && !fs.existsSync(path.join(docsHarness, target))) {
      stale.push(target);
    }
  }

  if (isFix) {
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
      const targetSections = [];
      for (const t of item.tags) {
        targetSections.push(`## TAG: [${t.replace(/[\[\]]/g, '')}]`);
      }
      const parts = relPath.split('/');
      if (parts.length > 1) targetSections.push(`### ${parts.slice(0, 2).join('/')}/`);
      targetSections.push(`### ${parts[0]}/`);

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
    if (missing.length > 0 || stale.length > 0) {
      console.log('Synchronization check: FAILED');
      if (missing.length > 0) {
        console.log(`Missing from INDEX.md (${missing.length}):`);
        missing.forEach((m) => console.log(`  + ${m}`));
      }
      if (stale.length > 0) {
        console.log(`Stale links in INDEX.md (${stale.length}):`);
        stale.forEach((s) => console.log(`  - ${s}`));
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
