---
ctime: 2026-09-29
mtime: 2026-11-29
spdx: GPL-3.0-only
title: "dorothy"
description: "Conversational LLM interface"
tags:
  - llm
  - chatbot
  - dorothy
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/README.md
   -
   -->

# dorothy

Conversational LLM interface

Dorothy is an assistant with a memory of her own: a chat in the terminal,
and an identity and memory she carries into Claude Code, Codex and Pi. She
runs on the Vercel AI SDK, reaching Anthropic and the other providers her
`config.toml` names. The [wiki](./docs/README.md) explains her, subject by
subject.

## Setup

Bun >=1.4 runs her from source. [mise](https://mise.jdx.dev) supplies Bun,
sops, age and jq, and runs the development tasks. `--claude` needs Claude
Code signed in; `--pi` needs Node >=22.19.0 and a Featherless key.

```sh
mise install
bun install
```

## Secrets

`secrets.json` is committed, encrypted with
[sops](https://github.com/getsops/sops) to the age key in
`~/.config/sops/age/keys.txt` (under `$XDG_CONFIG_HOME` if set). Dorothy
loads it when a command needs credentials; a nonempty variable already in
the environment wins.

```sh
sops edit secrets.json
```

It holds `ANTHROPIC_API_KEY`; `OPENROUTER_API_KEY`, `FEATHERLESS_API_KEY`
and `HF_TOKEN` for the other providers; `CLAUDE_CODE_OAUTH_TOKEN` for the
evaluation's `claude` routes, or one per account under names that begin
so, chosen by `DOROTHY_CLAUDE_TOKEN_VAR`; and `DOROTHY_MIRROR_KEY` and
`DOROTHY_MIRROR_TOKEN` for her memory's encrypted mirror.

Back up two keys off this machine, as nothing can read what they lock
without them: the age key, and the mirror key, which this prints:

```sh
sops decrypt --extract '["DOROTHY_MIRROR_KEY"]' secrets.json
```

A new machine needs its own age key. Add its recipient to `.sops.yaml`,
then, on a machine that can decrypt, run `sops updatekeys secrets.json`
and commit both files.

## Usage

```sh
bun run dev                          # chat in the terminal
bun run dev -- "What is your name?"  # one reply
bun run dev -- --claude              # Claude Code, as Dorothy
bun run dev -- --serve               # her memory service
bun run dev -- --help                # every command
bun run eval -- --help               # measuring her memory
```

Bun runs `dev` only inside this checkout; elsewhere, call the entry point:

```sh
alias dorothy="bun $PWD/packages/cli/src/index.ts"  # from this checkout
```

Her data is in `~/.local/share/dorothy` and her caches in
`~/.cache/dorothy`. Her settings are in `~/.config/dorothy/config.toml`,
read at startup: the status lines, providers and model routes,
compaction, memory, history, the service and recording. Each location
moves with its `XDG_*` variable. The wiki's
[models and routing](./docs/wiki/topics/models-and-routing.md) and
[memory](./docs/wiki/topics/memory.md) explain the settings, and
[`config.ts`](./packages/core/src/config.ts) parses them.

## Development

[`AGENTS.md`](./AGENTS.md) and each package's own describe the nine
workspace packages under `packages/`.

- `mise install`: the tools, the packages and the git hooks.
- `mise run check --all` (or `bun run check`): everything CI runs.
- `mise run lint` and `mise run format`: hk over the changed files.
- `mise run test`: the tests alone; `mise tasks ls`: the rest.
- `mise run commit`: compose a commit.

The pre-commit hook runs `mise run lint --staged`, and the commit-msg
hook commitlint. CI runs the shared standard workflow, then
`bun run check`.

<!-- vim:set expandtab shiftwidth=2 filetype=markdown foldlevel=3: -->
