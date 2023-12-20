SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
METHOD=${1:-dry-run}

cd $SCRIPT_DIR/../src/fib-wasm
wasm-pack build --release

cd $SCRIPT_DIR/../third_party/zkWasm
export RUST_LOG=info

# 100
cargo run --release -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 100:i64 --public 3314859971:i64
# 10000
# cargo run --release -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 10000:i64 --public 1242044891:i64
# 100000
# cargo run --release -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 100000:i64 --public 873876091:i64

# cuda
# 100
# cargo run --release --features cuda -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 100:i64 --public 3314859971:i64
# 10000
# cargo run --release --features cuda -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 10000:i64 --public 1242044891:i64
# 100000
# cargo run --release --features cuda -- -k 22 --function zkmain --wasm $SCRIPT_DIR/../src/fib-wasm/pkg/fib_wasm_bg.wasm $METHOD --public 100000:i64 --public 873876091:i64