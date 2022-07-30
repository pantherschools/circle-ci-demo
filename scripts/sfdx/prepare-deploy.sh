#!/usr/bin/env sh

# Where did this branch originate from ?
TRUNK=master

# What branch am I on ?
THIS_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🔄 Current Branch => \n $THIS_BRANCH"
# Find the base of this branch :
BASE=$(git log $TRUNK..$THIS_BRANCH | grep commit | tail -n 1 | sed 's/commit //g')
# If you just want to find changes since last commit (for CI, for example), use this :
#BASE=HEAD^
#sfdx sgd:source:delta --to develop --from master --output .
FROM=$BASE

echo "🔄 Base is.\n $BASE"

# Generate manifest/deploy/package.xml containing changes on this branch since the BASE
# It generates the following output :
#   manifest/deploy/package.xml
#   manifest/deploy/destructiveChanges/package.xml
#   manifest/deploy/destructiveChanges/destructiveChanges.xml
# This uses https://github.com/scolladon/sfdx-plugin-ci which in turn uses https://github.com/scolladon/sfdx-git-delta
#sfdx plugins:install sfdx-plugin-ci
#sfdx source:delta:generate --repo . --from $BASE --to HEAD --output ../manifest/.