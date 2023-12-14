#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
METHOD=${1:-dry-run}

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

export RUST_LOG=info
$SCRIPT_DIR/../src/zkvm-wasmi/target/release/wasm --wasm $SCRIPT_DIR/../output/fib.wasm --public 1556111435:i64 --method $METHOD