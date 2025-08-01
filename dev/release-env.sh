#!/bin/sh -exu

export DEV_INITIALS=uvb
export RELEASE_MAJOR_MINOR=4.10
export RELEASE_PATCH=0
export RELEASE_PRE='' # '-RC.1'; or '' for stable release
export VERSION_PREFIX='v'

export RELEASE_MAIN="$RELEASE_MAJOR_MINOR.$RELEASE_PATCH"
export RELEASE="$RELEASE_MAIN$RELEASE_PRE"
export RELEASE_NAME="$VERSION_PREFIX$RELEASE"

echo "RELEASE_MAIN: $RELEASE_MAIN"
echo "RELEASE: $RELEASE"
echo "RELEASE_NAME: $RELEASE_NAME"
