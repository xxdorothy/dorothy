---
ctime: 2026-11-29
mtime: 2026-11-29
spdx: GPL-3.0-only
title: Validation through hk
description: >-
  The shared hk steps and mise task templates of shared-config replacing
  husky and Dorothy's own lint tasks, with the pre-commit hook's timings
  before and after, and the outstanding work reconciled with the
  monorepository settlement.
tags:
  - config
  - verification
  - report
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/reports/2026-11-29_hk-validation.md
   -
   -->

# Validation through hk

On 2026-11-29, after the
[monorepository settlement](./2026-11-29_monorepository-settlement.md),
the user named the pre-commit hook the most outstanding work: too slow for
granular commits and too verbose for an agent's context. They asked the
repository to conform to `chewygumxx/shared-config`, whose repositories
lint through hk with shared steps and quiet output. The reasoning now
lives on the wiki's
[build configuration](../wiki/topics/build-configuration.md#hk) page and
in the
[decision](../wiki/decisions.md#validation-runs-through-the-shared-hk-steps-and-mise-templates).

## Before

The husky pre-commit hook ran `mise run check --staged`: each `lint:*`
task over the staged files, then `tsc`, the headers, the skills lock and
the whole test suite. Measured in the main checkout at `c8c2676`:

| Part | Time |
| --- | --- |
| `mise run lint --staged`, nothing staged | 21.9 s |
| `lint:types` (`tsc`) | 2.1 s |
| `bun test`, 4787 tests | 157.9 s |

Most of the 21.9 seconds was mise hashing the `**/*` source sets of four
tasks, about 3.5 seconds each, before any linter ran. Every task printed
its command line, and a failure its tool's full report.

## What changed

- The standard tasks extend the `cgxx:` templates of
  `@chewygumxx/mise-tasks-config` 0.3.2, linked into `.config/mise/conf.d/`.
  `lint.task.toml`, `format.task.toml` and `scripts/with-files.sh` are
  gone.
- `.config/hk.pkl` takes the steps of `@chewygumxx/hk-config` 0.3.1 and
  adds `secrets` and `skills`. cspell, knip, secretlint and `packages`
  are left out.
- hk replaces husky: `mise install` installs the `pre-commit` and
  `commit-msg` hooks into git's configuration. Pre-commit runs
  `mise run lint --staged`; the tests run in CI and on `mise run check`.
- `post-checkout` and `post-merge` move to `scripts/hooks/`, registered
  in git's configuration by `prepare`, which also unsets husky's
  `core.hooksPath`.
- Biome goes to 2.6.9 and the shared configuration's recommended preset,
  leaving Markdown and YAML to their tools. markdownlint's configuration
  returns to the root; Prettier gains `.config/prettierrc.json`; Tombi
  goes to 1.11.3, as the shared step passes flags 1.5.5 lacks.
- `CGXX_WIDEN_ON` leaves out `packages`, which here is the code.
- The shared ShellCheck configuration's optional checks asked for a
  default in 22 `case` statements and the hoisting of 11 command
  substitutions, across ten scripts; probe captures under
  `docs/reports/**/probe/` are excluded instead, kept as they ran.

## After

Measured on the branch, `env -u FORCE_COLOR`:

| Run | Time | Output |
| --- | --- | --- |
| Commit of the migration, widened to every file | 8.9 s | none |
| Commit of one test file | 0.9 s | none |
| Commit of an em dash, rejected | 1.6 s | the step's error |
| `mise run lint --all`, uncached | 9.3 s | one line |
| `mise run lint --all`, cached | 2.9 s | one line |

A passing run prints `[lint] $ bun run cgxx-hk check` alone. The
commit-msg hook rejected a message that was not a Conventional Commit. A
throwaway worktree, added with `git worktree add`, installed itself in 8
seconds through the registered `post-checkout` hook and then passed
`mise run lint --all`. `bun run check`, now `mise run check --all`, passed
whole.

## Outstanding work, reconciled

The settlement retired the split as a gate. Of the
[unfinished work report](./2026-11-22_unfinished-work.md):

- Section 1 is settled: the split is off, `0ca74d0` and the uncommitted
  edits it named are gone from `main` (#151 dropped the include), and the
  restructure handoff no longer exists in the parent directory. Its
  Phase C, the shared setup with hk and no husky, is this change.
- Sections 2 to 4 stand: the Codex live probe and the rulings on Hermes,
  OpenClaw, the objective, orchestration and the herdr registry remain
  the user's, and the Revising steps owed since 2026-11-11 remain owed.
- Section 5: Dependabot's #141 and #123 are superseded by the Biome 2.6.9
  and `@chewygumxx/biome-config` 1.3.1 bumps here.
- The settlement's optional Nx and ADR trials remain optional and
  separate; neither gates the roadmap.

## Limits

- A commit no longer runs the tests; a failing test first shows in CI.
- cspell, knip and secretlint, shared steps, are not adopted; each awaits
  a change of its own across the existing tree.
- Another clone, such as `dorothy.clone`, keeps husky's hooks until a
  `bun install` there unsets `core.hooksPath` and `mise install` installs
  hk's.
