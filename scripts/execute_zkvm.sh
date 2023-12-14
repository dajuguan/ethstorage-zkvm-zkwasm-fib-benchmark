#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

export RUST_LOG=info
$SCRIPT_DIR/../src/zkvm-wasmi/target/release/wasm --wasm $SCRIPT_DIR/../output/fib.wasm --public 873876091:i64 --method execute