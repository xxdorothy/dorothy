---
ctime: 2026-11-29
mtime: 2026-11-29
spdx: GPL-3.0-only
title: Codex live probe
description: >-
  The delivery's last live check: Dorothy launched in Codex 0.172.0 on a
  temporary home the user signed in, her hooks trusted, her answer from
  memory, the payloads captured and the sweep recording the sessions.
tags:
  - delivery
  - codex
  - verification
  - report
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/reports/2026-11-29_codex-probe.md
   -
   -->

# Codex live probe

The [delivery report](./2026-11-01-delivery.md#waiting-for-the-user) left
Step 4, Codex with the user, waiting since 2026-11-01. On 2026-11-29 the
user signed a temporary Codex home in, and the probe ran. It was the last
live check of [Dorothy's Memory](../roadmap.md#dorothys-memory), as the
user had backlogged Hermes and OpenClaw the same day.

## Setup

- Codex 0.172.0, `CODEX_HOME` at
  `~/.local/share/dorothy-codex-probe/codex`, signed in by the user with
  `codex login`; nothing was copied from their own Codex home.
- A probe Dorothy on temporary `XDG_*` roots under a `mktemp -d`
  directory, her service on port 47123, holding one fact, the user's
  favourite colour (teal), seeded as the delivery plan's Step 2 gives it.
- Dorothy from `main` at `0f09817`, run as `bun "$E"` with
  `E=packages/cli/src/index.ts`; Codex in a scratch directory.

Nothing reached the user's store, service or Codex configuration. The
service was stopped by its pid afterwards.

## What it showed

The open questions of the
[probes' record](./2026-11-01-delivery/probes.md), answered:

| Question | Answer |
| --- | --- |
| Are hooks from session flags offered for trust? | Yes: "2 hooks are new or changed", with a review screen |
| What does trusting write? | `[hooks.state]` entries keyed `/<session-flags>/config.toml:<event>:0:0`, each a `trusted_hash` |
| Is `developer_instructions` accepted, and additive? | Yes, no unknown-key warning; her core follows Codex's own as a second developer message |
| Do the block and recall arrive? | Yes, as developer messages, `<memory>` then `<recalled>` |
| Did she answer from memory? | "Teal!" in `exec`; "Teal" in the interactive interface |
| Do the payloads match the fixtures? | Yes, plus a `permission_mode` field in both |
| Does the sweep record the rollout? | Yes, the user's turn and her answer, nothing of the hooks' text |

The plugin route the delivery spec held in reserve is not needed: Codex
trusts hooks given as session flags. The one launch warning was Codex's
"Running without the shared background server", which any `-c` override
raises.

### Trust

`bun "$E" --codex` showed Codex's "Hooks need review" screen. Its review
listed one `SessionStart` and one `UserPromptSubmit` hook awaiting trust;
`t` trusted both, and Codex wrote:

```toml
[hooks.state."/<session-flags>/config.toml:session_start:0:0"]
trusted_hash = "sha256:5f8fb08e6b649d5b31a5217ff5cf0c907fe026c2cdb2b552ade7950f3fc7b4ca"

[hooks.state."/<session-flags>/config.toml:user_prompt_submit:0:0"]
trusted_hash = "sha256:aeae14dfe523dc5479b33f39d28a402ae5288585cef997d2410f3f79df0f23ec"
```

The trust is keyed by the hook's position and hash, so a change to her
hook command asks again.

### The answer

```sh
bun "$E" --codex exec --skip-git-repo-check "what is my favourite colour?"
```

```text
hook: SessionStart
hook: SessionStart Completed
hook: UserPromptSubmit
hook: UserPromptSubmit Completed
codex
Teal!
```

The rollout's developer messages ran: Codex's own instructions, her core,
Codex's skills, permissions, collaboration mode, tools and plugins, then
her `<memory>` block and her `<recalled>` item for the teal fact.

### The payloads

A second launch swapped each hook for a wrapper that kept its stdin and
then ran her hook command; the wrapper's hooks were trusted the same way.
In the interactive interface she answered "Teal". The payloads, with the
transcript path shortened:

```json
{"session_id":"01a2236c-b0e5-7313-84f6-44a125db89ff","transcript_path":"…/rollout-….jsonl","cwd":"/tmp/dorothy-probe.DvttPz/work","hook_event_name":"SessionStart","model":"gpt-6.2-sol","permission_mode":"default","source":"startup"}
{"session_id":"01a2236c-b0e5-7313-84f6-44a125db89ff","turn_id":"01a2236c-cc01-7572-a22a-ac7ce3e168ba","transcript_path":"…/rollout-….jsonl","cwd":"/tmp/dorothy-probe.DvttPz/work","hook_event_name":"UserPromptSubmit","model":"gpt-6.2-sol","permission_mode":"default","prompt":"what is my favourite colour? answer in one word, no tools"}
```

They are the fixtures' shape, which came from the strings of Codex
0.165.0's binary, with one field more, `permission_mode`, which her hook
ignores. The fixtures now carry it.

The wrapper's first version called `bun` by name, which resolved to a mise
shim that refused the scratch directory, and both hooks failed. Her own
hook command names Bun by its absolute path, so it is not exposed to that.

### The sweep

The sweep needs `codex` in `[recording] hosts`. Its first run marked the
`exec` session, which predated it, as waiting for the backfill, as
designed. A second `exec` session, after it, was recorded live: a session
event, the user's question and her answer, with no hook text.

```text
codex: 2 events in 1 session (1 waiting for the backfill)
```

## Fixed on the way

- The sweep warned of two record types new in Codex 0.172.0:
  `response_item/additional_tools`, the tools Codex offers the model, and
  `event_msg/turn_aborted`, left by an interrupted turn. Both are now
  bookkeeping the reader passes over.
- Her Codex profile's `checked` gains 0.172.0, so the launcher no longer
  warns that the version is unchecked.
- The hook fixtures gain `permission_mode`.

## Limits

- One account, one model (`gpt-6.2-sol`), one fact; recall over a large
  memory was verified without Codex on 2026-11-01.
- The MCP tools were offered but not called: Codex asked to run `brief`
  once, and the probe declined it.
- The backfill of a session older than the first sweep was not run.
