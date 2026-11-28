---
ctime: 2026-11-11
mtime: 2026-11-29
spdx: GPL-3.0-only
title: .config/AGENTS.md
description: >-
  The tools configured in .config/ and how each finds its configuration
  there.
tags:
  - agents
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/.config/AGENTS.md
   -
   -->

# .config/AGENTS.md

Tool configuration lives here wherever the tool can be pointed at it.
Each line names a tool, its file and how the tool reaches it.

- mise: `mise/config.toml` (tools, `[env]`, the `postinstall` hook), read
  natively, includes `mise/tasks/*.task.toml` by `[task_config]`.
  `standard.task.toml` holds the standard tasks, each extending a `cgxx:`
  template that `mise/conf.d/` links from
  `@chewygumxx/mise-tasks-config`; `bun.task.toml` the tasks wrapping
  Bun's layer and `other.task.toml` the rest.
- hk: `hk.pkl`, the hooks and the lint and format steps, imported from
  `@chewygumxx/hk-config`; mise's tasks run hk, which finds it natively.
- Tombi: `tombi.toml`; Tombi finds it natively.
- remark: `remarkrc.json`; hk's `remark` step passes `--rc-path`.
- Prettier: `prettierrc.json`, naming `@chewygumxx/prettier-config`; hk's
  `prettier` step passes `--config`.
- yamllint: no file here; hk's `yamllint` step sets
  `YAMLLINT_CONFIG_FILE` to `@chewygumxx/yamllint-config`.

Biome (`.biome.json`), commitlint (`.commitlintrc.mts`) and
markdownlint-cli2 (`.markdownlint-cli2.jsonc`) stay at the root: Biome
refuses a configuration in a subdirectory as a second root, commitlint's
search omits `.config/`, and hk's shared step lets markdownlint-cli2 find
its own. The reasons for each tool's configuration, and what else stays
at the root, are on the wiki's
[build configuration](../docs/wiki/topics/build-configuration.md) page.
