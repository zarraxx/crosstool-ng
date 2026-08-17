#!/bin/bash
set -e

ROOT_DIR=$(dirname "$(readlink -f "$0")")

IMAGE=ghcr.io/zarraxx/crosstool-ng:1.28.0
ARCHIVE_DIR=$ROOT_DIR/archives
DIST=$ROOT_DIR/dist
mkdir -p $DIST
mkdir -p $ARCHIVE_DIR

ARCH=$(uname -m)
LIBC=${LIBC:-gnu}
case "$LIBC" in
    gnu|musl) ;;
    *)
        echo "Unsupported LIBC: $LIBC (expected gnu or musl)" >&2
        exit 1
        ;;
esac

TRIPLE=${TRIPLE:-$ARCH-unknown-linux-$LIBC}
HOST=${HOST:-native}
CTNG_ACTION=${CTNG_ACTION:-build}

podman run --rm -it \
    --userns=keep-id \
    -e LINES=50 -e COLUMNS=160 -e TRIPLE=$TRIPLE -e HOST=$HOST -e LIBC=$LIBC \
    -e CTNG_ACTION=$CTNG_ACTION \
    -v $ARCHIVE_DIR:/home/ctng/src \
    -v $ROOT_DIR/ctng_workspace:/home/ctng/workspace \
    -v $ROOT_DIR/container_script:/home/ctng/scripts \
    -v $DIST:/home/ctng/x-tools \
    $IMAGE \
    bash /home/ctng/scripts/build_toolchain.sh
