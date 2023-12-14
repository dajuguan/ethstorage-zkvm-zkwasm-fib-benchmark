# Project Description

This project is for [Eth Storage Grant 1](https://github.com/ethstorage/EthStorage-Grant?tab=readme-ov-file#grant-1)

# Summary

Compare zkWasm/zkVM DryRun/Witness/Prove Benchmark

5 Control Groups
1. `zkWasm` fib_zkgo.go -> zkGo -> fib.wasm -> zkWasm
2. `wasmi` fib_zkgo.go -> zkGo -> fib.wasm -> wasmi -> RiscV ELF -> zkVM
3. `tinygo` fib.go -> tinygo -> RiscV ELF -> zkVM
4. `zkVM` fib.rs -> RiscV ELF -> zkVM
5. `cuda` fib.rs -> RiscV ELF -> zkVM(cuda)

## N=10000
|         | zkWasm  | wasmi   | tinygo  | zkVM    | cuda    |
| ------- | ------- | ------- | ------- | ------- | ------- |
| dryrun  | 0.77s   | ❌(tech) | ❌(tech) | ❌(tech) | ❌(tech) |
| witness | 143.4s  | 323s    | ❌(tech) | 0.54s   | 0.54s   |
| prove   | ❌(tech) | ❌(perf) | ❌(tech) | ~2h     | 144s    |

## N=100000
|         | zkWasm  | wasmi   | tinygo  | zkVM    | cuda    |
| ------- | ------- | ------- | ------- | ------- | ------- |
| dryrun  | 17s     | ❌(tech) | ❌(tech) | ❌(tech) | ❌(tech) |
| witness | ❌(perf) | ❌(perf) | ❌(tech) | 49.9s   | 49.9s   |
| prove   | ❌(perf) | ❌(perf) | ❌(tech) | ❌(tech) | ~50m    |

## Explain

❌(tech) means cannot perform due to program error
❌(perf) means cannot perform due to too long execution time (usually longer than 2 hours)

### Test Enviroment

13700K 5.30 Ghz 16cores
64GB RAM
RTX 4090

zkWasm witness N=10000 running on
AMD 5950X 3.4Ghz 16core
128GB RAM

### Additional Info
1. risc0/tinygo is not compatible with zkvm currently
2. zkWasm prove failed because of panicked at `crates/zkwasm/src/circuits/utils/table_entry.rs:153:22` when free memory is only 6GB of 128GB
3. most test for N=100000 failed due to performance

# How to reproduce

On x86-64 Ubuntu-22.04 with sudo access

### clone this project

```
git clone --recurse-submodules https://github.com/apuslabs/ethstorage-zkvm-zkwasm-fib-benchmark.git
```

if submodules is not cloned,run follow commands mamually
```
cd ethstorage-zkvm-zkwasm-fib-benchmark
git submodule init
git submodule add https://github.com/apuslabs/risc0.git third_party/risc0
git submodule add https://github.com/apuslabs/zkWasm.git third_party/zkWasm
git submoduole add -b zkGo https://github.com/apuslabs/go.git third_party/go
cd third_party/zkWasm
git submodule init
git submodule update
```

### install dependencies

```
apt install build-essential
apt install cmake
apt install clang
apt install lld
apt install pkg-config
apt install libssl-dev
```

install go
```
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

install rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

install risc0 toolchain
```
cargo install cargo-binstall
cargo binstall cargo-risczero
cargo risczero install
```

build zkGo
```
cd third_party/go/src
./all.bash
```

build zkWasm
```
cd third_party/zkWasm
cargo build --release
```

build risc0
```
cd third_party/risc0
cargo build --release
```

build zkvm-fib/zkvm-wasmi
```
cd src/zkvm-fib
cargo build --release
cd src/zkvm-wasmi
cargo build --release
```

### run script

```
cd scripts

# test zkwasm
./zkwasm.sh dry-run
./zkwasm.sh single-witness
./zkwasm.sh single-prove

# test zkvm
./zkvm.sh execute
./zkvm.sh prove

# test wasmi
./wasmi.sh execute
./wasmi.sh prove
```

### cuda

Downlolad [CUDA tookit](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=runfile_local)
make sure your NVIDIA driver is installed and support latest CUDA toolkit
Run the `./cuda_xxx.run`

```
./cuda_xxx.run
export PATH=$PATH:/usr/local/cuda-12.3/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.3/lib64
```

```
cd src/zkvm-wasmi
cargo build --release --features cuda
cd src/zkvm-fib
cargo build --release 
```


### tinygo

tinygo built from source using LLVM, the following use built image

```
cd third_party/tinygo
sudo dkpg -i tinygo_amd64.deb
tar -xzf tinygo.linux-amd64.tar.gz
export PATH=$PATH:tinygo/bin
```

```
tinygo build -target zkvm fib_go.go
r0vm --elf fib_go
```

# Insight

## what we do

1. add `single-witness` command for zkWasm
2. add time log for zkWasm/zkVM
3. make fib.wasm run on wasmi on zkVM
4. try risc0/tinygo and built fib_go and try run in zkVM
5. try cuda prove

## What we have found

### zkWasm vs zkVM witness time

N=10000
zkWasm: 143.4s
zkVM: 323s

we think this is not fair
because zkWasm record all trace in memory and write it to file
zkVM record segments as file
and zkVM runs wasmi, wasmi run fib.wasm, the wasm VM costs.

### cycles index grothing

for both zkWasm & zkVM
when N=10000 goes to N=100000

the execution trace measurement instrction cycles grouth up by index

### tinygo
tinygo is not ready for zkVM, we can work on it

### cuda
cuda accelarate is obvious, it shake-off the sha256，poseidon_hal，poseidon254_hal to GPU