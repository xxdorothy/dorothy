---
name: target-harnesses
description: "Pi, Claude Code and Codex are Dorothy's hosts; Hermes and OpenClaw backlogged"
metadata:
  node_type: memory
  ctime: 2026-10-19
  mtime: 2026-11-29
  spdx: GPL-3.0-only
  type: project
  originSessionId: fb965535-b7ef-4fd4-8065-6767fb16ee58
  modified: 2026-11-03T06:58:45.000Z
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/memory/target-harnesses.md
   -
   -->

On 2026-10-19 the user named the harnesses Dorothy is provided for and
tested against: Claude Code, Codex, OpenClaw and Hermes Agent. This
answers the open question of which harnesses come first, which the
[protocol diversity](./protocol-diverse-dorothy.md) ruling left until
her memory was designed.

**Why:** they had settled it before the memory work began, and held it
back until memory across harnesses was resolved.

On 2026-11-03, after reviewing the available agents and the repository's
[Pi research](../notes/2026-11-03_pi-stewardship.md), the user made
Pi "by far, our highest priority". Stewardship and orchestration are the
chief interest, like the development agents managing one another through
herdr. This supersedes the earlier exclusion and the four-host priority.

**How to apply:** Pi comes first for integration design and capability
testing. The other four remain existing delivery targets; this decision
does not say to remove them or replace Dorothy's runtime. The
[roadmap](../roadmap.md) records the order.

The user then chose Pi's own interface over embedding its SDK behind
Dorothy's existing interface. The
[delivery design](../specs/2026-11-03_pi-delivery.md) covers
the launcher, extension, memory adapter and stewardship trial. The user
approved it, then authorised execution without another plan approval
round. Follow the delivery and stewardship plans linked from the roadmap.

On 2026-11-29 the user backlogged Hermes and OpenClaw: what is built for
them stays, and their probes, readers and delivery wait in the roadmap's
candidates. Stewardship and orchestration are no longer the interest:
the user ruled that Dorothy is not an orchestration agent
([her objective](./dorothy-objective.md)), and disqualified the herdr
registry, as herdr's terminal interface has stagnated upstream.
