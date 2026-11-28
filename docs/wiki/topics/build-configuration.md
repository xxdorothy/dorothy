---
ctime: 2026-11-11
mtime: 2026-11-29
spdx: GPL-3.0-only
title: Build configuration
description: >-
  How the repository's tools are configured: mise's tasks beside Bun's
  layer, where each configuration lives, and the reasons kept out of it.
tags:
  - wiki
  - workflow
  - config
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/wiki/topics/build-configuration.md
   -
   -->

# Build configuration

[Wiki home](../../README.md)

This page holds the reasoning the repository's configuration no longer
carries. By the root [`AGENTS.md`](../../../AGENTS.md#rules),
a configuration keeps its directives, labels, reference URL and any
one-line why; anything longer is here, a section per tool.
[`.config/AGENTS.md`](../../../.config/AGENTS.md) lists the tools
configured in `.config/` and what mise supplies each to find it. What the
checks run is on [repository workflow](./repository-workflow.md#the-checks),
and the design is the
[build configuration spec](../../specs/2026-11-10_build-configuration.md).

## Two layers

mise is the development interface, but Bun is the only utility expected
wherever Dorothy runs. So every development action is a mise task, defined
once in `.config/mise/tasks/` or taken from the shared templates, and
every action that must run without
mise stays in Bun's layer: `package.json`'s `prepare`, `dev`, `start`,
`eval` and `scripts/`. `bun install`, `prepare` and Dorothy's entry
points never call mise, and no task runs a `bun run` script that calls
`mise run` back. `bun run check` is `mise run check --all`, kept because
the shared CI calls it.

## Where configuration lives

Configuration goes under `.config/` wherever its tool finds it there,
natively or by a flag or variable mise supplies: mise's own, hk's,
Tombi's, remark's and Prettier's. yamllint needs no file at all. Each move
to `.config/` was probed first, as the tool sections record; Biome's and
commitlint's failed, and markdownlint's returned to the root with hk
([Markdown](#markdown)).

The rest stay because their tools or the shared CI read them where they
are. That is the repository's reading of each tool's documentation or of
the shared CI, not a probe, and an inference where marked:

- `.biome.json` and `.commitlintrc.mts`: probed; see [Biome](#biome) and
  [commitlint](#commitlint).
- `.markdownlint-cli2.jsonc`: see [Markdown](#markdown).
- `.editorconfig`: editors and editorconfig-checker look for it from each
  file upward, and `root = true` ends the search here
  ([EditorConfig](https://editorconfig.org/)).
- `.gitignore` and `.gitattributes`: git reads them in the tree they
  govern ([gitignore](https://git-scm.com/docs/gitignore),
  [gitattributes](https://git-scm.com/docs/gitattributes)).
- `bunfig.toml`: Bun reads it from the project root
  ([bunfig](https://bun.com/docs/runtime/bunfig)), and Bun's layer cannot
  rely on mise to point it elsewhere.
- `tsconfig.json`: Bun reads it at run time, as the spec records, and
  `tsc` run without `--project` looks for it from the working directory
  upward
  ([tsconfig](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)).
- `.shellcheckrc`: the shared CI's scope looks for it at the root.
- `.sops.yaml` and `secrets.json`: Dorothy's runtime configuration, whose
  move is a roadmap candidate of its own; see [sops](#sops).
- `.moxide.toml`: see [Markdown Oxide](#markdown-oxide).
- `.repo-metadata.jsonc`: the default path of the shared standard
  workflow's `metadata-path` input, in `chewygumxx/.github`'s
  `standard.yaml`.
- `skills-lock.json`: the skills CLI reads the lock beside `package.json`
  (`readLocalLock(cwd)` in its `dist/cli.mjs`), so it stays at the root.
- `.github/`: GitHub reads workflows and Dependabot's configuration only
  there. What the workflow runs and promises is in
  [`ci.md`](../../../.github/workflows/ci.md), beside it.
- `package.json`'s `config.commitizen`: commitizen's README names
  `package.json` and a `.czrc` as where its adapter is configured, and
  does not mention `.config/`
  ([cz-cli](https://github.com/commitizen/cz-cli#readme)); unprobed.

## mise

`.config/mise/config.toml` pins the tools, settings and `[env]`; mise
reads it natively there, and it includes `.config/mise/tasks/*.task.toml`
through `[task_config]`, one file to a family of tasks. CI installs the
same tools from it with `jdx/mise-action`. `min_version` is 2026.11.6, the
release the shared task templates are written for.
Everything the repository runs that Bun does not install is pinned there,
so a checkout never depends on what a contributor has on `PATH`; npm
packages are pinned in `package.json` and installed by Bun, and the two
files are the whole dependency surface. Backends are named explicitly
(`aqua:`, `pypi:`, `conda:`), so the resolution is visible and cannot
change underneath a pin. `experimental = true` is there because the
`git::` remote task behind `act` needs it.

The standard tasks (`install`, `lint`, `format`, `test`, `check`,
`commit`, `commit:lint`, `act`) extend the `cgxx:` templates of
`@chewygumxx/mise-tasks-config`, as the user's other repositories do.
mise reads the templates through the links in `.config/mise/conf.d/` into
`node_modules`, so they appear once `bun install` has run; the
`postinstall` hook makes `mise install` run `bun ci` and then
`hk install --mise`, outside CI. `lint` and `format` run hk through the
package's `cgxx-hk`, which turns `--staged`, `--all` and `--step` into
hk's selection and keeps hk quiet unless `--verbose` is given.

`CGXX_WIDEN_ON` names the paths whose change widens a run to every file:
`bun.lock`, `.config` and the root tool configurations. The shared
templates list `packages` too, where the shared configurations live; here
`packages/` is the code, and widening on it would lint the whole tree on
nearly every commit.

Until 2026-11-29 the tasks were Dorothy's own: a `lint:*` task per tool,
each handed its files by `scripts/with-files.sh` and skipped by mise's
`sources` and `outputs`. The pre-commit hook ran `check --staged`, the
whole test suite included, and a `lint --staged` with nothing staged
still took about 22 seconds, mise hashing each `**/*` source set; with the
tests a commit took over three minutes. hk's own selection and cache
replaced both ([hk](#hk)).

## Bun

`bunfig.toml` sets four things:

- `[run] bun = true`: every package script runs on Bun, the CLIs whose
  shebang names `node` included. `bun run` puts a `node` that is Bun first
  on `PATH`, for nested scripts too, so a Node installed elsewhere, such as
  a CI runner's, never runs them.
- `[install] linker = "isolated"`: each package sees only what its
  `package.json` declares, so an undeclared import fails to resolve under
  Bun and `tsc` alike.
- `[env] file = false`: core loads the sops-encrypted `secrets.json`, and
  Bun must not preload a `.env` from the working directory into Dorothy's
  environment.
- `[test] preload`: `test-setup.ts` runs before any test file. It sets
  `FORCE_COLOR=0`, so the frames the tests compare are plain text whatever
  the shell says, gives the cache, state and runtime directories temporary
  roots, so no test touches the user's, and drops git's `GIT_*` variables,
  which the pre-commit hook sets and which would let a test running git in
  a scratch repository write the real one.

## Biome

`.biome.json` stays at the root. Biome treats a configuration in a
subdirectory as a second, nested root and refuses to run, whether it is
found by path or given by `BIOME_CONFIG_PATH` or `--config-path` (probed
2026-11-11). It extends `@chewygumxx/biome-config`'s recommended
configuration, which already leaves out `secrets.json`, `skills-lock.json`
and Pi's vendored files, and, as the shared repositories do, leaves
Markdown and YAML to their own tools.

## commitlint

`.commitlintrc.mts` stays at the root. commitlint replaces cosmiconfig's
search places with a list that omits `.config/`, and the shared CI runs
commitlint with no `--config` (probed 2026-11-11). Its types, limits and
prompt come from `@chewygumxx/commitlint-config`; only the scopes are the
repository's.

## Git hooks

hk installs the validation hooks, `pre-commit` and `commit-msg`, into
git's configuration (`hook.hk-*`), which every worktree of a checkout
shares. `pre-commit` sets unstaged work aside and runs
`mise run lint --staged`; `commit-msg` runs `mise run commit:lint`.
`prepare` unsets husky's old `core.hooksPath`, which would hide them.

`post-checkout` and `post-merge`, in `scripts/hooks/`, decide when to run
`bun install`, which is Bun's layer, so they call no mise. hk cannot run
them: it loads `.config/hk.pkl`, which imports the shared steps from
`node_modules`, and a new worktree has none until the hook installs it.
So `scripts/hooks/install.sh`, run by `prepare`, registers them in git's
configuration as `hook.dorothy-*`, each running only where its script
exists, so a branch from before them checks out clean. `bun install`
reinstalls the dependencies and its `prepare` relinks the skills.

- `post-checkout` acts on a branch checkout alone (its third argument is
  `1`). A new worktree's first checkout, from the null commit, always
  installs, as its `node_modules` and links are not shared. Any other
  branch checkout installs only when it changes `package.json` or
  `bun.lock`; a file checkout does nothing.
- `post-merge` installs when a merge or pull changes `package.json` or
  `bun.lock`. It compares `ORIG_HEAD`, the head before the merge, with the
  working tree, not with `HEAD`, as a squash merge changes only the files
  and leaves `HEAD` where `ORIG_HEAD` is.

## hk

`.config/hk.pkl` maps the steps of `@chewygumxx/hk-config` into hk's
`check` and `fix` hooks, adding two of Dorothy's: `secrets`, which runs
`scripts/check-secrets.sh` on its files, and `skills`, the skills CLI's
frozen dry run against `skills-lock.json`. hk runs the steps in parallel
on the files it selects and records each passing step against its
files and configuration, so an unchanged step is skipped. A full
`mise run lint --all` took about 9 seconds uncached on 2026-11-29, where
the mise tasks took 55; a commit of one Markdown file, about a second.

The shared `cspell`, `knip` and `secretlint` steps are not yet adopted:
each would report across the existing tree, and adopting one is a change
of its own. `packages` is left out, as nothing here is published. Shell
captured as evidence under `docs/reports/**/probe/` is kept as it ran, so
ShellCheck and shfmt skip it.

## ShellCheck

hk runs ShellCheck with `@chewygumxx/shellcheck-config`, by
`SHELLCHECK_OPTS`, whose optional checks ask for a default in every
`case` and no command substitution masking a failure. Its
`external-sources=true` follows sourced files as `shellcheck -x` does, so
a script checks on its own. `.shellcheckrc` stays at the root, with the
same setting, for the shared CI. shfmt reads its style from
`.editorconfig`.

## Markdown

remark's configuration is `.config/remarkrc.json`, given by `--rc-path`.
markdownlint-cli2's is `.markdownlint-cli2.jsonc` at the root, where hk's
shared step lets markdownlint-cli2 find it, as in the user's other
repositories; it was `.config/markdownlint-cli2.jsonc`, given by
`--config`, until 2026-11-29. Both extend the house presets. The
overrides in `.github/`, `docs/memory/` and `packages/identity/` merge
over it for their own files: the pull request template's sections are
its headings, a memory opens with its fact, and the persona with its
prompt's first words, so none starts with a top-level heading. Biome
leaves Markdown to them.

## yamllint

yamllint has no file in the repository. hk's shared step sets
`YAMLLINT_CONFIG_FILE` to the house style in
`@chewygumxx/yamllint-config`, and the shared CI falls back to the same
style. Prettier formats YAML with `.config/prettierrc.json`, which names
`@chewygumxx/prettier-config`.

## Tombi

`.config/tombi.toml` is found natively, and the shared CI's scope lists
it. Its rules align the values within a group, the form the TOML
configuration follows.

## Worktrees

A new worktree needs no file copied from the main checkout. The
`post-checkout` hook runs `bun install`, whose `prepare` links every skill
through `node_modules` or a fetch, and points auto memory at the
worktree's own `docs/memory`. The shared template's `.worktreeinclude`,
which has Claude Code copy `node_modules`, is not needed here.
`.worktreeinclude`, which once had Claude Code and worktrunk copy the
skills that `skills add` installed, went when the skills became a
declared array
([decision](../decisions.md#agent-assets-are-declared-outside-agents-and-claude)).

## Markdown Oxide

`.moxide.toml` configures Markdown Oxide, the Markdown language server.
Its [configuration page](https://oxide.md/Configuration) names
`.moxide.toml` or `~/.config/moxide/settings.toml` but not where
`.moxide.toml` must be; that it is read at the root of the folder the
server serves, so it stays there, is unprobed. The comments copied
from the tool's template were deleted, as they restated its
documentation, which the file's reference URL now gives.

## sops

`.sops.yaml` and `secrets.json` are Dorothy's runtime configuration, and
moving them is a roadmap candidate of its own. core's `saveSecret` reads
`.sops.yaml` beside the file it writes. Whom the file is encrypted to is
in [`.sops.md`](../../../.sops.md), and how the secrets are kept is on
[repository workflow](./repository-workflow.md#secrets).

## Related

- [Repository workflow](./repository-workflow.md)
- [Decisions](../decisions.md#repository-workflow)
- [Records](../records.md#repository-workflow)
- [Implementation report](../../reports/2026-11-11_build-configuration.md)
