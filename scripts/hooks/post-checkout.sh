#!/usr/bin/env sh
# vim:set expandtab shiftwidth=4 filetype=sh:
# SPDX-License-Identifier: GPL-3.0-only

#
#
# ~xxdorothy/dorothy.git
# ::: :/scripts/hooks/post-checkout.sh
#
#

# Branch checkouts alone.
[ "$3" = 1 ] || exit 0
# From the null commit, a new worktree has no node_modules or links.
case $1 in *[!0]*) ;; *) exec bun install ;; esac
git diff --quiet "$1" "$2" -- package.json bun.lock && exit 0
bun install
