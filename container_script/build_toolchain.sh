#!/bin/bash

set -e
ARCH=$(uname -m)
ROOT_DIR=$(dirname "$(readlink -f "$0")")

TRIPLE=${TRIPLE:-$ARCH-unknown-linux-gnu}
GCC_MARJOR_VERSION=${GCC_VERSION:-15}

HOST=${HOST:-native}

if [[ "$HOST" != "native" ]]; then
    HOST_DIR_NAME=host-$HOST
    HOST_TOOLCHAIN_DIR=$(find "$HOME/x-tools" -maxdepth 1 -type d -name "$HOST-gcc*" | sort -V | tail -n 1)
    if [[ -z "$HOST_TOOLCHAIN_DIR" ]]; then
        echo "Host toolchain not found: $HOME/x-tools/$HOST-gcc*" >&2
        exit 1
    fi
    export PATH=$HOST_TOOLCHAIN_DIR/bin:$PATH
else
    HOST_DIR_NAME=native
fi

ls "$HOME/workspace/$HOST_DIR_NAME"
WORKSPACE_DIR=${WORKSPACE:-$HOME/workspace/$HOST_DIR_NAME}


cd "$WORKSPACE_DIR/$TRIPLE-gcc${GCC_MARJOR_VERSION}"

for attempt in 1 2 3; do
    if ct-ng source; then
        break
    fi

    if [[ "$attempt" -eq 3 ]]; then
        echo "ct-ng source failed after $attempt attempts" >&2
        exit 1
    fi

    sleep $((attempt * 30))
done

ct-ng build
