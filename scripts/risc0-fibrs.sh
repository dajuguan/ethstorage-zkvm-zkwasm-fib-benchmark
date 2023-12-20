#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

# read first arg from command line
# https://stackoverflow.com/questions/9332802/how-to-write-a-bash-script-that-takes-optional-input-arguments
METHOD=${1:-execute}

cd $SCRIPT_DIR/../src/zkvm-fib
export RUST_LOG=info

start_time=$(date +%s)

# 100
cargo run --release -- --iterations 100 --method $METHOD
# 10000
# cargo run --release -- --iterations 10000 --method $METHOD
# 100000
# cargo run --release -- --iterations 100000 --method $METHOD

# cuda
# cargo run --release -F cuda -- --iterations 100 --method $METHOD
# 10000
# cargo run --release -F cuda -- --iterations 10000 --method $METHOD
# 100000
# cargo run --release -F cuda -- --iterations 100000 --method $METHOD

end_time=$(date +%s)  # 记录命令执行完成的时间戳，单位为秒
execution_time=$((end_time - start_time))  # 计算命令执行时长，单位为秒

echo "Command execution time: $execution_time seconds"