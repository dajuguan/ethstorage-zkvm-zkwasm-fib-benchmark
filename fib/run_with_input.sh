#!/bin/bash
export GOROOT=/Users/jax/Desktop/ethstorage/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm /Users/jax/Desktop/ethstorage/go/bin/go build -gcflags=all=-d=softfloat -o fib_with_input.wasm fib_zkgo.go

echo 873876091 | python3 write_witness.py > input.dat

# Require node > 20
node ../zkWasm-emulator/wasi/wasi_exec_node.js fib_with_input.wasm input.dat

/Users/jax/Desktop/ethstorage/zkWasm/target/debug/delphinus-cli -k 22 --wasm fib_with_input.wasm  --function zkmain dry-run --public wasm:i64
