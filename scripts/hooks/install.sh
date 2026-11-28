#!/usr/bin/env sh
# vim:set expandtab shiftwidth=4 filetype=sh:
# SPDX-License-Identifier: GPL-3.0-only

#
#
# ~xxdorothy/dorothy.git
# ::: :/scripts/hooks/install.sh
#
#

# Registers the install hooks, post-checkout.sh and post-merge.sh, in git's
# configuration, which every worktree of the checkout shares. hk installs
# the rest, but hk loads .config/hk.pkl from node_modules, which a new
# worktree lacks until post-checkout.sh installs it. Each hook runs only
# where its script exists, so a branch from before them checks out clean.
# Retires husky's core.hooksPath, which would hide hk's hooks.

set -eu

git rev-parse --git-dir >/dev/null 2>&1 || exit 0

for event in post-checkout post-merge; do
    git config --local --replace-all "hook.dorothy-$event.event" "$event"
    git config --local --replace-all "hook.dorothy-$event.command" \
        "test ! -f scripts/hooks/$event.sh || sh scripts/hooks/$event.sh"
done

if [ "$(git config --local core.hooksPath || :)" = .husky/_ ]; then
    git config --local --unset core.hooksPath
fi
