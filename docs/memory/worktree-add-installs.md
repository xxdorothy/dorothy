---
name: worktree-add-installs
description: "git worktree add runs bun install and the branch's prepare via post-checkout"
metadata:
  node_type: memory
  ctime: 2026-11-15
  mtime: 2026-11-15
  spdx: GPL-3.0-only
  type: reference
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/memory/worktree-add-installs.md
   -
   -->

`git worktree add` fires the shared `.husky/post-checkout` hook, which
runs a full `bun install` in the new worktree, lifecycle scripts and all.
On an old branch that means the old branch's own `prepare` runs, whatever
flags a later install is given. On 2026-11-15 a throwaway worktree of
`proto/orchestration` ran its `prepare`, which linked skills, wrote the
worktree's `.claude/settings.local.json` and re-set the shared
`core.hooksPath`.

**How to apply:** to inspect or test a stale branch without its scripts,
add the worktree with `git -c core.hooksPath=/dev/null worktree add`,
then install with `bun install --ignore-scripts`. See the
[orchestration prototype report](../reports/2026-11-15_orchestration-prototype.md).
