---
ctime: 2026-11-15
mtime: 2026-11-15
spdx: GPL-3.0-only
title: Orchestration prototype, suspended
description: >-
  The state of the two unmerged orchestration prototype branches as of
  2026-11-15: how they relate, what Part A they build and lack, where
  they depart from the spec, their tests, and how to resume the work.
tags:
  - orchestration
  - report
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/reports/2026-11-15_orchestration-prototype.md
   -
   -->

# Orchestration prototype, suspended

Part A of the [orchestration spec](../specs/2026-11-02-orchestration-design.md)
was prototyped on 2026-11-02 and suspended unmerged. This report is an
evaluation of the local branches made on 2026-11-15, written so that an
agent resuming the work need not reconstruct it. The verdict: the
prototype is not fit to merge as it stands, since Part A is incomplete
and nothing on the roadmap calls for it, but it is about 12,000 lines of
tested work on the hardest parts of the design, and both branches are
kept.

## The refs

| Ref                                    | Tip       | Keep for                          |
| -------------------------------------- | --------- | --------------------------------- |
| `proto/orchestration`                  | `3c17fd1` | The prototype: T1 to T15 and R1   |
| `proto/orchestration-codex`            | `54503f5` | The original line, T8 as specced  |
| tag `archive/orchestration-codex`      | `54503f5` | The same, should the branch go    |

Both branches are on `origin`, matching the local ones. Both fork from
`b506ee6`, the merge of the spec, and were 240 commits behind `main`
(`c0f892c`) on 2026-11-15. The plan they followed, with tasks T1 to T16
at least, was never committed to any branch; the task names survive only
in commit subjects. A third branch, `backup/local-main`, was a snapshot
of `main` from 2026-11-11 whose three commits had all reached `main` in
later forms; the user deleted it on 2026-11-15.

## How the two branches relate

They are not two implementations, and the Codex branch is not a
snapshot taken for review. Author and commit times, all on 2026-11-02
in Melbourne (+1100), show one line of work, rewritten and rejoined:

1. T1 to T9 and `fixup! T7 tests` (14:53) were committed on one line,
   the line `proto/orchestration-codex` still holds.
2. At 14:57, T7 to T9 were rewritten onto what became
   `proto/orchestration`: the fixup squashed into T7, and T8 changed
   (see [the departure](#a-departure-from-the-spec)). Every rewritten
   commit there carries the commit time 14:57.
3. From 15:01 to 15:29, T10 and T11 were built on `proto/orchestration`
   while T12 to T14 were built on the original line, then cherry-picked
   unchanged at 15:29; their author times precede T10's and T11's.
   The branch's name suggests Codex built T12 to T14, but no record
   says who built what.
4. `proto/orchestration` alone went on to T15 (22:58 to 23:06) and the
   review round R1 (23:31 to 23:38).

`git range-diff` confirms it, run from the fork point `6caf307` (T6),
which both branches share:

```text
$ git range-diff -s 6caf307..proto/orchestration-codex \
    6caf307..proto/orchestration
 1:  74e0e3b !  1:  3877a76 T7 tests
 2:  9678657 =  2:  f2fb3b6 feat: T7 code, the worker box
 3:  37f758b !  3:  481cecc test: T8 tests, the real-agent gate
 4:  354ada2 !  4:  482c0fa feat: T8 code, the real-agent gate
 5:  a75949a =  5:  6eb3b71 test: T9 tests, sealed git and worker clones
 6:  919c062 =  6:  fe4e404 feat: T9 code, sealed git and worker clones
 7:  9473e96 <  -:  ------- fixup! T7 tests
 -:  ------- >  7:  017d4d5 test: T10 tests, fetch, push and pull requests
 -:  ------- >  8:  b9e5845 feat: T10 code, fetch, push and pull requests
 -:  ------- >  9:  3d356bf test: T11 tests, operations
 -:  ------- > 10:  4f14b27 feat: T11 code, operations
 8:  a88a0ed = 11:  2e21272 test: T12 tests, shell and permission rules
 9:  9ae1a51 = 12:  2972f40 feat: T12 code, shell and permission rules
10:  089ea33 = 13:  2341f9f test: T13 tests, judge and permission gate
11:  3c166fd = 14:  ec484e9 feat: T13 code, judge and permission gate
12:  ec79d68 = 15:  7437581 test: T14 tests, elicitation questions
13:  54503f5 = 16:  af4530d feat: T14 code, elicitation questions
 -:  ------- > 17:  8a7423a test: T15 tests, the engine
 -:  ------- > 18:  6e472cb feat: T15 code, the engine
 -:  ------- > 19:  f5aab32 test: R1 tests, review regressions
 -:  ------- > 20:  3c17fd1 fix: R1 code, review findings
```

T7's tests differ only in import order, the fixup's lint fix. T8 is the
one real difference.

## What is built

Each task is a tests commit followed by a code commit. Paths are under
`packages/orchestra/` unless they name another package.

| Task | What it builds                                  | Where                        |
| ---- | ----------------------------------------------- | ---------------------------- |
| T1   | The `approval` role, empty unless configured    | `core` models and contracts  |
| T2   | `[orchestra]` in `config.toml`, the package     | `src/config.ts`, `core`      |
| T3   | The server re-run with a clean environment      | `src/environment.ts`         |
| T4   | The bubblewrap box and its socket bridge        | `src/box/{box,bridge}.ts`    |
| T5   | The egress proxy and public-address checks      | `src/net/proxy.ts`           |
| T6   | The key gateway for API key logins              | `src/net/key-gateway.ts`     |
| T7   | A worker's box: adapter, login, proxy variables | `src/box/worker-box.ts`      |
| T8   | The real-agent gate, a live check run by hand   | `scripts/real-agent-gate.ts` |
| T9   | Sealed host git, the broker, clones, branches   | `src/broker/`                |
| T10  | Fetch, push and pull requests via the broker    | `src/broker/`                |
| T11  | Operations, their queue, cancellation and close | `src/operations.ts`          |
| T12  | Shell parsing and the permission rules          | `src/rules.ts`, `shell.ts`   |
| T13  | The judge and the permission gate               | `src/gate.ts`, `judge.ts`    |
| T14  | Elicitation questions to the user               | `src/questions.ts`           |
| T15  | The engine: workers on acpx, one session each   | `src/engine/`                |
| R1   | Review fixes across the broker and the engine   | most of the above            |

The package's own `AGENTS.md` and `src/engine/AGENTS.md` on the branch
describe every file and invariant, and are the best place to start.

## What is missing

- **T16 and on: the tools and the server.** T15's message names its
  functions as "for Task 16". No MCP server or tool layer exists, the
  package exports no entry point (its guide says "None yet"), and
  `dorothy --orchestra-server` is not wired into `cli`.
- **Part B**, Dorothy's chat as the first client, is not started.
- **The live gate run.** The spec makes each merge wait on the
  real-agent gate run with signed-in agents and recorded in a report
  ([verification](../specs/2026-11-02-orchestration-design.md#verification)).
  No record of such a run was found.
- **A roadmap phase and the user's acceptance.** The roadmap orders no
  orchestration phase, though the spec's
  [Documentation](../specs/2026-11-02-orchestration-design.md#documentation)
  section would add one ahead of Dorothy's Gateway, and the
  [wiki](../wiki/topics/orchestration.md) notes that the spec does not
  record the user accepting the whole design.
- **The plan.** It must be rewritten, from the spec, the commits and the
  package's guide.

## A departure from the spec

The spec has the gate check "the session reloaded" (Verification) and
the engine set the agent's mode "with each new or reloaded session"
([the box](../specs/2026-11-02-orchestration-design.md#the-box)).

- The original T8, kept on `proto/orchestration-codex` and the tag,
  does what the spec says: it shuts the runtime down, reconnects the
  stored session with a new one, sets the mode and checks that a turn
  keeps both. Each turn has a 300-second timeout.
- The rewritten T8 on `proto/orchestration` replaces that check with
  "box survives turns, a setMode and a pause": one agent process
  through several turns and an idle pause (`--pause`, 15 seconds by
  default; 310 is said to outlast every acpx timer). It drops the turn
  timeout, noting that acpx kills the box of a turn that fails.
- T15's engine follows the rewrite. Its guide states the invariant: a
  worker has one agent process, one box and one session for its life,
  with no turn timeout, and an agent that exits or restarts fails the
  worker. The engine never reloads a session.

The commit messages were not updated and the spec was not amended, so
the reason is unrecorded. The likeliest reading, an inference, is that
acpx's handling of failed turns made a reloaded session start a second
agent outside the box's single process, and that a persistent session
was simpler to confine. Whoever resumes must either restore the reload
check or amend the spec, and record the ruling.

## Verification

The prototype's tests were run on 2026-11-15 in a throwaway worktree of
`proto/orchestration`, on its own base:

```text
$ bun test packages/orchestra
 367 pass
 0 fail
 814 expect() calls
Ran 367 tests across 25 files. [66.48s]
```

Neither `bun run check` nor the tests of other packages were run on the
branch, and nothing was run against `main`. A trial merge into `main`
with `git merge-tree --write-tree --name-only` conflicts in two files on
each branch:

```text
proto/orchestration:        bun.lock, workspace.test.ts
proto/orchestration-codex:  bun.lock, workspace.test.ts
```

Since the fork, `main` has also changed in ways the trial merge does not
show:

- headers moved from `~chewygumxx` to `~xxdorothy`; every file of the
  package carries the old one;
- the `skills` package joined the workspace, and the root `AGENTS.md`
  and `workspace.test.ts` pin the package graph that `orchestra` would
  join;
- development runs through mise tasks under `.config/mise/`, with
  header, wiki and Markdown checks the prototype predates;
- the four `core` files that T1 and T2 change differ by 15 lines, so
  those changes port cheaply.

A throwaway worktree runs more than it seems to. `git worktree add`
fires `main`'s `post-checkout` hook, which runs `bun install` with the
checked-out branch's lifecycle scripts, so the old branch's `prepare`
ran in the worktree whatever flags a later install took. Here it linked
skills and wrote `.claude/settings.local.json` inside the worktree, and
re-set `core.hooksPath` to the value it already held. To skip it, add
the worktree with `git -c core.hooksPath=/dev/null worktree add`.

## Resuming

1. Ask the user to accept the design and to place an orchestration
   phase in the roadmap; only the roadmap orders work.
2. Rule on the session reload, as [above](#a-departure-from-the-spec),
   and amend the spec if the persistent session stands.
3. Write the plan with `writing-plans`, from the spec, the task table
   above and the package's guide on `proto/orchestration`, for T16 on:
   the MCP tools, the server and its CLI flag. Part B gets its own plan.
4. Start a new branch from `main` rather than rebasing 32 prototype
   commits. Bring the package over by path, then reapply T1's and T2's
   `core` changes by hand:

   ```sh
   git checkout proto/orchestration -- packages/orchestra
   ```

5. Sync the headers with `mise run format:header`, regenerate
   `bun.lock`, add the package to `workspace.test.ts` and the root
   `AGENTS.md`, and pass `bun run check` before building on it.
6. Run the real-agent gate live once the agents' usage allows, and
   record it in a report before Part A merges.

The branches and the tag can go once the work is merged and the reload
ruling is recorded.
