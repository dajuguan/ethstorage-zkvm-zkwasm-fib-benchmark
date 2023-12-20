#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
# execute/prove
METHOD=${1:-execute}

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

cd $SCRIPT_DIR/../src/zkvm-wasmi
export RUST_LOG=info

# 100
cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 3314859971:i64 --method $METHOD
# 10000
# cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 1556111435:i64 --method $METHOD
# 100000
# cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 873876091:i64 --method $METHOD

# cuda
# 100
# cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 3314859971:i64 --method $METHOD
# 10000
# cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 1556111435:i64 --method $METHOD
# 100000
# cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 873876091:i64 --method $METHOD