#!/bin/bash

set -e
ARCH=$(uname -m)
ROOT_DIR=$(dirname "$(readlink -f "$0")")

ls $HOME/workspace/native
WORKSPACE_DIR=${WORKSPACE:-$HOME/workspace/native}
TRIPLE=${TRIPLE:-$ARCH-unknown-linux-gnu}
GCC_MARJOR_VERSION=${GCC_VERSION:-15}

cd $WORKSPACE_DIR/$TRIPLE-gcc${GCC_MARJOR_VERSION}
ct-ng build