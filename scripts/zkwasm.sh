#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
METHOD=${1:-dry-run}

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

$SCRIPT_DIR/../third_party/zkWasm/target/release/delphinus-cli -k 22 --wasm $SCRIPT_DIR/../output/fib.wasm  --function zkmain $METHOD --public 873876091:i64
