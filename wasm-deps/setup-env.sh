#!/bin/bash
# Environment setup for WASM cross-compilation

export TARGET="$PWD/wasm-deps/target"
export CPATH="$TARGET/include"
export PKG_CONFIG_PATH="$TARGET/lib/pkgconfig"
export EM_PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
export CFLAGS="-O3 -pthread -DWASM_BIGINT"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-sWASM_BIGINT -sASYNCIFY=1 -L$TARGET/lib"

echo "Environment configured for WASM cross-compilation:"
echo "TARGET: $TARGET"
echo "PKG_CONFIG_PATH: $PKG_CONFIG_PATH"
echo "CFLAGS: $CFLAGS"