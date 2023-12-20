#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
# execute/prove
METHOD=${1:-execute}

export GOROOT=$SCRIPT_DIR/../third_party/go
# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $SCRIPT_DIR/../third_party/go/bin/go build -gcflags=all=-d=softfloat -o $SCRIPT_DIR/../output/fib.wasm $SCRIPT_DIR/../src/fib_zkgo.go

cd $SCRIPT_DIR/../src/zkvm-wasmi
export RUST_LOG=info

start_time=$(date +%s)

# 100
# cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 3314859971:i64 --method $METHOD
# 10000
# cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 1556111435:i64 --method $METHOD
# 100000
# cargo run --release -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 873876091:i64 --method $METHOD

# cuda
# 100
cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 3314859971:i64 --method $METHOD
# 10000
# cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 1556111435:i64 --method $METHOD
# 100000
# cargo run --release -F cuda -- --wasm $SCRIPT_DIR/../output/fib.wasm --public 873876091:i64 --method $METHOD

end_time=$(date +%s)  # 记录命令执行完成的时间戳，单位为秒
execution_time=$((end_time - start_time))  # 计算命令执行时长，单位为秒

echo "Command execution time: $execution_time seconds"