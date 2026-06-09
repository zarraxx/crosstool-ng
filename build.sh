#!/bin/bash
set -e

ROOT_DIR=$(dirname "$(readlink -f "$0")")

IMAGE=ghcr.io/zarraxx/crosstool-ng:1.28.0
ARCHIVE_DIR=$ROOT_DIR/archives
DIST=$ROOT_DIR/dist
mkdir -p $DIST
mkdir -p $ARCHIVE_DIR

ARCH=$(uname -m)
TRIPLE=${TRIPLE:-$ARCH-unknown-linux-gnu}

podman run --rm -it \
    --userns=keep-id \
    -e LINES=50 -e COLUMNS=160 -e TRIPLE=$TRIPLE \
    -v $ARCHIVE_DIR:/home/ctng/src \
    -v $ROOT_DIR/ctng_workspace:/home/ctng/workspace \
    -v $ROOT_DIR/container_script:/home/ctng/scripts \
    -v $DIST:/home/ctng/x-tools \
    $IMAGE \
    bash #/home/ctng/scripts/build_toolchain.sh