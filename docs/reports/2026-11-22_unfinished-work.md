---
ctime: 2026-11-22
mtime: 2026-11-22
spdx: GPL-3.0-only
title: Unfinished work before the next phase
description: >-
  A read-only audit on 2026-11-22 of the phased work left unfinished: the
  open Memory phase, the roadmap revisions owed since 2026-11-11, the
  rulings only the user can make, a planned repository split, and the
  repository's housekeeping.
tags:
  - roadmap
  - report
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/reports/2026-11-22_unfinished-work.md
   -
   -->

# Unfinished work before the next phase

The user asked on 2026-11-22 what phased work was started and never
finished, and what must be completed before further phased work begins.
The verdict: the roadmap's first phase in Ahead,
[Dorothy's Memory](../roadmap.md#dorothys-memory), is still open, and no
later phase has begun. Four things stand before the next: a repository
split planned outside this repository, the Memory phase's last pieces,
the roadmap's Revising steps owed for work merged since 2026-11-11, and
rulings that are the user's alone. Housekeeping follows them.

## Method

The audit changed nothing in the main checkout. It read the
[roadmap](../roadmap.md), the [priorities](../wiki/priorities.md), every
spec, plan and report dated from 2026-11-06, agent memory and the git
state. Four read-only subagents then audited, in parallel: the Memory
phase's remaining pieces; the Revising procedure against each merge since
2026-11-11; the repository's state, its checks and open pull requests;
and orchestration against the objective the persona spec states. The
claims below that cite a line were checked against `ce79218`, the tip of
`origin/main`.

`git fetch` over SSH failed in the agent's shell, refused for want of a
public key, so the GitHub API confirmed `origin/main`:

```text
$ gh api repos/xxdorothy/dorothy/branches/main --jq '.commit.sha[0:7]'
ce79218
```

## 1. A gate outside the repository: the split

A handoff in the parent directory,
`~/dev/xxdy/xxdy-restructure-handoff.local.prompt.md` (2026-11-21), plans
to retire `xxdorothy/.config` and bring the organisation's repositories
to the shared setup of the user's other repositories (mise tasks from
shared packages, hk for every check, no husky). It opens: "Do not start
until the user says the repository consolidation is done", for this
repository and its nine packages "are to be split into several
repositories, some private".

The main checkout already holds early pieces of its Phase C:

- `main` is one commit ahead of `origin/main`: `0ca74d0`, "build: Fix
  reference to raw github", committed on `main` rather than a branch.
  It changes only the URL of the monorepo `include` that #148 added. The
  handoff says to drop or supersede it.
- Uncommitted, `.config/mise/config.toml` removes that `include` whole.
  Nothing reads its `proj_*` variables or `XXDY_PROJ_*` environment.
- Uncommitted, `package.json` raises Biome from 2.5.15 to 2.6.8, the
  exact version `hk-config` pins in `~/dev/shared-config`. The bump is
  half done: `bun.lock`, the installed CLI and `.biome.json`'s `$schema`
  still say 2.5.15.

**For the user:** has the consolidation begun? If this repository is
about to be split, phased work inside it may wait for the split, and the
two edits and `0ca74d0` are settled by the handoff's plan.

## 2. Dorothy's Memory, still open

Its Status (roadmap, Ahead) still reads "Delivery Built for Codex and
Hermes, its Live Probes Waiting on the User; OpenClaw's Waiting on its
Install".

| Piece | State | Needs |
| --- | --- | --- |
| Codex live probe | Never run | The user's sign-in, one short turn |
| Hermes live probe | Never run; Hermes called archived | A ruling, then a probe or none |
| OpenClaw | Installed, documented as not | A ruling: in the phase or deferred |
| Probe report and Status | Not written | Then the Revising steps |

- **Codex.** The delivery report's
  [Waiting for the user](./2026-11-01-delivery.md#waiting-for-the-user)
  asks for a signed-in temporary `CODEX_HOME`, the hook trust screen,
  `dorothy --codex exec` answering from her memory, and a sweep of the
  rollout. No report, commit or `eval` record shows it run. The persona
  work's host probe (`persona/hosts/20261114/codex.json` in `eval`)
  launched `dorothy --codex` live with memory off; it covered
  instructions and the `persona` tool, not hooks, recall or the sweep.
  [Priorities](../wiki/priorities.md#blocked-on-the-user) still waits
  for Codex "after 5 November 17:23".
- **Hermes.** "Hermes is archived" appears only in the persona work: the
  [amendment](../specs/2026-11-14_persona-design.md#amendment-native-subagents-off-2026-11-14),
  the [hosts guide](../../packages/cli/src/hosts/AGENTS.md#subagents) and
  the decision on native subagents in
  [decisions](../wiki/decisions.md). No decision records who archived it
  or when, and the decision naming
  [the four harnesses](../wiki/decisions.md#the-four-harnesses-are-claude-code-codex-openclaw-and-hermes)
  still includes it. If it is retired, its probe leaves the phase and the
  roadmap, priorities, decisions and harness profile change with it.
- **OpenClaw.** `~/.local/bin/openclaw` has existed since 2026-11-03, yet
  the roadmap and the [harness profile](../wiki/profiles/harnesses.md)
  say it waits on its install. No ruling says whether it remains a target
  since Pi took priority on 2026-11-03; its reader and delivery are
  already candidates.
- **Not blockers.** Pi's production wiring check was run, as the harness
  profile records. The chunk index belongs to Relations and Embeddings;
  only its sentence in the phase's Rationale reads as pending.

## 3. Revising steps owed

The roadmap's [Revising](../roadmap.md#revising) section lists six steps
after any merge. Its last Revisions line is dated 2026-11-11.

- **Persona (#147, merged 2026-11-15).**
  - No Done entry and no Revisions line.
  - Its follow-ups are in no candidate: the distress classifier the user
    chose; the experience machinery (recording, appraisal, decay and
    routing); chat's prompt, as
    [`persona.ts`](../../packages/agent/src/persona.ts) still says she
    has no tools and cannot read files; the
    [report's](./2026-11-14_persona-check.md#evidence-limits) evidence
    limits; and the probe gaps the hosts guide lists.
  - Step 3 is unasked: the spec's new objective (section 4) bears on
    Ahead's order.
  - `xxdorothy/eval#3`, the check's evidence, is open with 11 commits.
    Once it merges, the hosts guide's pointer to "branch `persona`"
    changes.
- **Repository configuration of agent assets (#145, #146).** In Done,
  with no Revisions line; nothing records that PR 1's Step 10 gate held.
- **Development evidence (#136, #137) and Pi evidence preservation
  (#134).** Registered in the records with a wiki topic, but with no
  Done entry and no Revisions line, though the build configuration, also
  outside Ahead, has both.
- **The move to `xxdorothy` (#143) and the smaller merges of
  2026-11-13.** One Revisions line would record them.
- **Stale text.** Priorities' Codex date (section 2), and the
  [orchestration topic's](../wiki/topics/orchestration.md) "as of
  2026-11-03".
- **A misplaced record.** The persona spec and plan are catalogued under
  [Related](../wiki/records.md#related), after its links, not under
  [Identity, harnesses and delivery](../wiki/records.md#identity-harnesses-and-delivery)
  beside the persona check. `docs.test.ts` checks that a record is
  listed, not where.

## 4. Rulings only the user can make

1. **The objective.** The persona spec's
   [Dependencies](../specs/2026-11-14_persona-design.md#dependencies)
   say the repository's "new objective is subagent orchestration, with
   Dorothy as the user's primary liaison". The roadmap was not reordered
   for it, and `AGENTS.md`, `README.md` and `docs/README.md` still call
   her "a conversational LLM interface". Is it to reorder Ahead, or is it
   direction alone?
2. **Orchestration.** The
   [design](../specs/2026-11-02-orchestration-design.md) records no
   acceptance; its Documentation section asks for a phase ahead of
   Dorothy's Gateway. The
   [prototype](./2026-11-15_orchestration-prototype.md) on
   `proto/orchestration`, 32 commits ahead of `origin/main` and 243
   behind, lacks T16 on, the MCP tools and server, and departs from the
   spec on session reload, a departure no record explains. It blocks no
   phase unless orchestration becomes the main line; then the report's
   Resuming steps come first.
3. **The herdr registry.** High priority, taken up "when the user says".
   Herdr agent names are still written into
   `packages/skills/skills/agent-stewardship/`: `SKILL.md` and its
   `codex`, `budgets`, `recovery` and `herdr` references; and into
   [self-compaction](../memory/self-compaction.md).
4. **Hermes and OpenClaw**, as in section 2.

## 5. Housekeeping

- **Claude's memory directory.** The main checkout's
  `.claude/settings.local.json` sets `autoMemoryDirectory` to
  `~/dev/xxdy/dorothy/main/docs/memory`, a path from before the checkout
  moved. Claude's memories land in an untracked, empty `main/` at the
  root, not in `docs/memory`, and that directory makes `main` ambiguous
  to git (`git log main` asks for `--`). Re-running
  `bun scripts/agent-memory.ts` there and removing `main/` fixes it; a
  fresh worktree's prepare wrote the right path.
- **Branches.** `backup/local-main` still exists locally, though the
  orchestration report says the user deleted it; its three commits are on
  `main` in later forms. On `origin`, `build/agent-assets`,
  `build/config-mise-tasks`, `build/monorepo-project-metadata`,
  `build/repo-config` and `docs/orchestration-prototype-report` are
  merged. `proto/orchestration`, `proto/orchestration-codex` and the tag
  `archive/orchestration-codex` are kept on purpose.
- **Dependabot.** Open, with these check runs failing:

  | PR | Bump | Failing |
  | --- | --- | --- |
  | #141 | Biome 2.6.6 | `check` (schema pin), `header-sync` |
  | #142 | `@langchain/openai` 1.8.2 | `header-sync` |
  | #123 | `@chewygumxx/biome-config` 1.1.0 | `check`, from 2026-11-03 |
  | #124 | `ink` 8.0.0, a major version | None |
  | #127 | `openevals` 0.2.3 | None |

  The uncommitted Biome 2.6.8 overlaps #141.
- **Headers.** `docs/memory/MEMORY.md`, `bg-session-force-color.md`,
  `dorothy-ambition.md` and `nested-claude-session-env.md` carry no house
  header. `lint:header` warns; it does not fail.

## Verification

The checks ran on the main checkout as it stood, `0ca74d0` with both
uncommitted edits. `mise run lint` exited 0 across every linter in
55.33 seconds, with 88 header warnings: mostly capture files under
`docs/reports/`, then the four memory files above, a spec's HTML diagram
and a vendored file. `mise run test` passed whole:

```text
$ mise run test
[test] $ bun test
bun test v1.4.5 (a7733435c)

 4787 pass
 0 fail
 150143 expect() calls
Ran 4787 tests across 228 files. [162.47s]
```

The 48 failures in an agent's shell that the roadmap's Candidates
describe did not recur in this session. Running the tests set off mise's
automatic pruning, which removed node 26.5.1 and `ccstatusline` 2.2.32
from mise's installs; node 26.13.1 and `ccstatusline` 2.2.34, the
versions the configurations use, remain.

Open pull requests and their check runs were read from GitHub:

```sh
gh pr list -R xxdorothy/dorothy --state open \
  --json number,statusCheckRollup
gh pr view 3 -R xxdorothy/eval --json state,commits
```

## What follows

In order, each settling what the next depends on:

1. The user's rulings: the split (section 1), the objective and
   orchestration (section 4), Hermes and OpenClaw (section 2).
2. The Codex live probe with the user's sign-in, and Hermes's if it
   stays; then their report.
3. One documentation branch closing the Memory phase and paying the
   revisions of section 3, after the Revising steps.
4. The housekeeping of section 5.
