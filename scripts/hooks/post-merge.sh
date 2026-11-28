#!/usr/bin/env sh
# vim:set expandtab shiftwidth=4 filetype=sh:
# SPDX-License-Identifier: GPL-3.0-only

#
#
# ~xxdorothy/dorothy.git
# ::: :/scripts/hooks/post-merge.sh
#
#

# Against the work tree, as a squash merge leaves HEAD at ORIG_HEAD.
git diff --quiet ORIG_HEAD -- package.json bun.lock && exit 0
bun install
