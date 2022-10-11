#!/usr/bin/env sh

# Where did this branch originate from ?
TRUNK=master

# What branch am I on ?
THIS_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🔄 Current Branch => \n $THIS_BRANCH"
# Find the base of this branch :
BASE=$(git log $TRUNK..$THIS_BRANCH | grep commit | tail -n 1 | sed 's/commit //g')
BASE=$(git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')
# If you just want to find changes since last commit (for CI, for example), use this :
#BASE=HEAD^
#sfdx sgd:source:delta --to develop --from master --output .
FROM=$BASE

echo "🔄 Base is.\n $BASE"

# Install Delta Generation Tool
sfdx plugins:install sfdx-git-delta

# Generate manifest/deploy/package.xml containing changes on this branch since the BASE
# It generates the following output :
#   manifest/deploy/package.xml
#   manifest/deploy/destructiveChanges/package.xml
#   manifest/deploy/destructiveChanges/destructiveChanges.xml
# This uses https://developer.salesforce.com/blogs/2021/01/optimizing-unpackaged-deployments-using-a-delta-generation-tool

sfdx sgd:source:delta --to $THIS_BRANCH --from $FROM --output ./delta
