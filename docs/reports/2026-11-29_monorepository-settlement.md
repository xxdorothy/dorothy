---
ctime: 2026-11-29
mtime: 2026-11-29
spdx: GPL-3.0-only
title: Monorepository settlement
description: >-
  The user's ruling to retain Dorothy's modular monorepository, resume
  development, and evaluate graph tooling without another migration gate.
tags:
  - repository
  - architecture
  - agents
---

<!--
   -
   - ~xxdorothy/dorothy.git
   - ::: :/docs/reports/2026-11-29_monorepository-settlement.md
   -
   -->

# Monorepository settlement

## Ruling

Accepted by the user on 2026-11-29: retain Dorothy as a modular
monorepository. Keep documentation in this repository. The proposed split
in the [unfinished work report](./2026-11-22_unfinished-work.md) is no
longer a gate to functional development. Neither Nx adoption nor ADR
migration is a prerequisite for the next functional commit.

Resume the [roadmap](../roadmap.md), with Memory still first. Reconcile the
local restructure handoff and any uncommitted work with the user before
acting on it; do not discard local changes. Unrelated configuration work,
private evidence storage and host acceptance checks remain separate.

## Rationale and evidence

Repository boundaries, software module boundaries and agent context
boundaries need not coincide. Microrepositories and documentation
extraction would add coordination costs and impede atomic changes to code,
tests and documentation.

The user reports that reviews and the agentic efficiency evaluation did
not establish a worthwhile context benefit from fragmentation. The
evaluation repository returned HTTP 404 to the GitHub integration; its
data and methodology were not independently verified.

Inspection of main at `49b909f8` confirmed nine private Bun workspace
packages, isolated linking, explicit exports, hierarchical guidance and
an enforced graph in [workspace.test.ts](../../workspace.test.ts).
About 73% of the 6.3 MB documentation tree consisted of plans and reports
by uncompressed byte size. These are storage measures, not token counts.
Historical material need not be loaded for routine work.

Reconsider extraction only for demonstrated independent access control,
ownership, distribution, release lifecycle or development efficiency.

## Agent handoff

- Read root and owning package guidance, relevant source and tests, then
  necessary contracts, living wiki topics and decisions. Consult dated
  specs, plans and reports only when their evidence matters.
- Preserve package topology, explicit exports and the dependency allowlist.
  The CLI remains the composition root. Avoid needless new layers.
- Establish read, write and verification scopes per task. Escalate changes
  outside the write scope, especially public interfaces and dependencies.
  Guidance is not an access-control mechanism.
- Use worktrees for concurrency. Verify affected consumers, preserve the
  full integration gate, test preload and agent commit provenance.
- Keep present behaviour in the wiki, decisions in the decision catalogue
  and historical evidence in dated records.

## Optional tooling trial

Bun owns runtime and workspaces; mise owns the development interface;
Biome, TypeScript and Bun test own validation. Nx would own project
introspection and, if justified, affected execution.

On a separate experimental branch only:

1. Pin Nx as a dev dependency and add minimal `nx.json` configuration.
   Verify Node execution; Bun workspace support is not a runtime guarantee.
2. Inspect the existing layout without moving packages:

   ```sh
   bunx --no-install nx show projects
   bunx --no-install nx graph --file=/tmp/dorothy-graph.json
   bunx --no-install nx show projects --affected --base=origin/main --head=HEAD
   ```

3. Compare the discovered graph with `workspace.test.ts`. Account for
   shared files, root test setup, assets and non-code dependencies. A
   memory change should affect CLI and eval; core affects its consumers.
   Check uncommitted-change behaviour separately.
4. Retain Nx only if discovery or verification improves. Introduce scoped
   targets later; preserve full checks and root test isolation. Cache only
   deterministic tasks, never live inference or effectful probes.
5. Prefer a harness-neutral skill or machine-readable CLI to mandatory
   MCP. Defer Nx Cloud, Lerna and Turborepo until justified.

Trial [adr-tools](https://github.com/npryce/adr-tools) or
[MADR](https://adr.github.io/madr/) separately. The existing
[decision catalogue](../wiki/decisions.md) remains authoritative until a
migration is agreed. Avoid duplicate decision stores; account for
concurrent worktree numbering and house headers.

## Verification limits

This is a handoff, not an Nx implementation or evaluation rerun. No source,
manifest or tool settings are changed. Local worktrees and the external
evaluation were not inspected.
