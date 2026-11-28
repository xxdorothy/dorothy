---
ctime: 2026-10-12
mtime: 2026-11-29
spdx: GPL-3.0-only
title: AGENTS.md
description: >-
  Every coding agent's guide to Dorothy: the rules that hold in every
  session, and where to read the rest.
tags:
  - agents
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/AGENTS.md
   -
   -->

# AGENTS.md

Dorothy is an LLM agent with a memory her service shares with other
harnesses. Bun runs her from source; there is no build.

## Where to read

- Nine `@dorothy/*` packages under `packages/`; `workspace.test.ts` pins
  what each may import. Read `packages/<name>/AGENTS.md` before working in
  one.
- Configuration: `.config/AGENTS.md`. Docs: `docs/AGENTS.md`. A topic:
  `docs/README.md`. The order of work: `docs/roadmap.md`.

## Commands

- `bun run check`: everything CI runs. `mise run test`: the tests alone.
  `mise tasks ls`: the rest. `lint` and `format` run hk over the changed
  files; `--staged`, `--all` or `--step <name>` narrow or widen them.
  Pre-commit lints the staged files alone; the tests run in CI.
- `bun run dev -- --help`: the CLI from source, and its commands.
- `mise install` installs the tools, the packages and hk's git hooks.
  `bun install` links the skills and points Claude's memory at
  `docs/memory`; `mise run skills` relinks.
- After removing a `@dorothy` dependency, reinstall from clean:
  `rm -rf node_modules packages/*/node_modules && bun install`.

## Rules

- Work on a branch, in the main checkout or a worktree. Push it, open a
  pull request and merge your own once CI passes. Repository settings
  change only through `.repo-metadata.jsonc`, after asking the user.
- Tests and probes never touch real user data (`$XDG_DATA_HOME/dorothy`,
  `$XDG_CACHE_HOME/dorothy`): pass in every root, key and environment.
- `secrets.json` is encrypted by sops. Change it only with
  `sops edit secrets.json` or core's `saveSecret`; never print a value or
  put one in argv or a URL.
- New subsystems speak standard protocols; a provider's SDK stays at a
  thin edge.
- Declare every agentic asset here (`package.json`'s `skills`,
  `packages/skills/`); a harness's own settings are the user's.
- A new file copies the house header from a sibling;
  `mise run format --step headers` syncs it.
- Keep each kind of data in its own file beside what it concerns; a split
  pair has a check that fails when the two disagree.
- A change to a package's architecture updates its `AGENTS.md`, and one
  to behaviour or a decision the wiki, in the same branch.

## Commits

Conventional Commits, made as you go: a header of at most 50 characters,
body lines of at most 72, no em dashes. Scopes are the package names,
`config`, `claude` and `api`; agent assets take the `ai` type. An
agent's commit ends with trailers naming its configuration and session,
for finding its transcript later, and nothing advertising a product. In
Claude Code, `$CLAUDE_CODE_SESSION_ID` gives the session; `$CLAUDE_EFFORT`
gives the effort at launch, which `/effort` may since have changed:

```text
Agent: claude-code
Model: claude-opus-5-5
Effort: high
Session: 0f6e2b1c-8a4d-4e5f-9b7a-3c2d1e0f9a8b
```

## Process

Design work starts with `brainstorming`, then a spec in `docs/specs/` and
a plan in `docs/plans/` (`writing-plans`), carried out with
`subagent-driven-development`; once merged, revise the roadmap as its
Revising section says. Bugs start with `systematic-debugging`, and
nothing is called done without `verification-before-completion`. Where a
skill names other paths, these rules win.

## Memory

Agent memory is `docs/memory/`, indexed by `MEMORY.md`: a list item
linking `./<name>.md`, its hook on the next line. Link memories by
relative Markdown link, never `[[...]]`, with no em dash and no line over
80 characters: the `remark`, `markdownlint` and `emdash` lint steps
reject them.
