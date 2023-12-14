#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

# read first arg from command line
# https://stackoverflow.com/questions/9332802/how-to-write-a-bash-script-that-takes-optional-input-arguments
METHOD=${1:-execute}

start_time=$(date +%s)
export RUST_LOG=info
$SCRIPT_DIR/../src/zkvm-fib/target/release/fib --iterations 100000 --method $METHOD
end_time=$(date +%s)  # 记录命令执行完成的时间戳，单位为秒

execution_time=$((end_time - start_time))  # 计算命令执行时长，单位为秒

echo "Command execution time: $execution_time seconds"