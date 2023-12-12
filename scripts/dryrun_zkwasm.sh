#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

# echo 873876091 | python3 write_witness.py > ../output/input.dat
echo 1242044891 | python3 write_witness.py > ../output/input.dat

# Require node > 20, test wasm
# node $SCRIPT_DIR/../zkWasm-emulator/wasi/wasi_exec_node.js $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../output/input.dat

# $SCRIPT_DIR/../third_party/zkWasm/target/debug/delphinus-cli -k 22 --wasm $SCRIPT_DIR/../output/fib.wasm  --function zkmain dry-run --public 873876091:i64
$SCRIPT_DIR/../third_party/zkWasm/target/debug/delphinus-cli -k 22 --wasm $SCRIPT_DIR/../output/fib.wasm  --function zkmain dry-run --public 1242044891:i64
