# Raw Requirements (`docs/raw-requirements/`)

> [!WARNING]
> This folder belongs to the User. It is the single source of truth for what
> the User wants from this repository and its Harness. AI agents read it; they
> do not create, edit, rename, move or delete anything here, even when a task
> asks them to fix, update or improve the Harness. When a requirement should
> change, whether the agent or the User raised it, the agent proposes the exact
> change in its reply; the User edits the file. The only exception is a User
> request that spells out the exact result: the text to write, or the file to
> add, rename or delete. A direction such as "make them match" is not exact.

## Read when

- the task creates or changes something a requirement here describes (a skill,
  a layer, a hook, Jev AI);
- the User asks whether the repository meets their requirements.

Compare the requirement with the implementation. Report any mismatch to the
User as a proposal: name the file and node, quote the current text, and
suggest either a code change or a requirement change. The requirement wins
until the User decides otherwise, but changing code to meet it still needs a
task that asks for that change.

## Layout

Each group of requirements gets a folder, and each item a JSON file named
after it. Together they form one tree whose root is "Harness rules":

```text
docs/raw-requirements/
├── skills/
│   ├── improve-harness.json      Harness rules > Skills > improve-harness
│   ├── writing-for-agents.json   Harness rules > Skills > writing-for-agents
│   ├── init-harness-repo.json    Harness rules > Skills > init-harness-repo
│   └── enhance-jev-ai.json       Harness rules > Skills > enhance-jev-ai
├── layers/
│   └── layers.json               Harness rules > layers
└── jev-ai/
    └── jev-ai.json               Harness rules > Jev AI
```

A new group means a new folder; a new item means a new JSON file.

## JSON format

Each file holds one node. A node is:

```json
{ "title": "Yêu cầu 1", "text": "verbatim requirement text", "children": [] }
```

- `title`: the label of a requirement line (the part before the first colon,
  such as `Purpose` or `Yêu cầu 2.1`), or the whole line when it has no label.
- `text`: the rest of the requirement in the User's own words, unchanged.
  Line breaks are `\n`; empty when the node only groups children.
- `children`: nested nodes, in the User's order.

The text stays in the User's wording and language. Its spelling, numbering and
naming are the User's. An agent never corrects them; it may point them out.
