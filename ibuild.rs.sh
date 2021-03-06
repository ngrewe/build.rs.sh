#!/bin/sh -eu

# This is the inner build script, running inside the container.

BUILD_DIR=`mktemp -d`
cp -r /rust/* $BUILD_DIR/
cd $BUILD_DIR
rm -rf target
ln -s /target target
cargo build --release "$@"
BINARY=`find target/x86_64-unknown-linux-musl/release/ -maxdepth 1 -type f -not -iname "*.d" -not -iname ".cargo-lock"` 
strip $BINARY
