# Project Description

This project is for [Eth Storage Grant 1](https://github.com/ethstorage/EthStorage-Grant?tab=readme-ov-file#grant-1)

# Summary

Compare fib.go/fib.rs zkWasm/risc0 DryRun/Witness/Prove Benchmark


## fib.go
Control Groups
1. `zkWasm` fib_zkgo.go -> zkGo -> fib.wasm -> zkWasm
2. `zkWasm(cuda)` fib_zkgo.go -> zkGo -> fib.wasm -> zkWasm(cuda)  (❌due to cuda 12.3 not compatible)
3. `risc0` fib_zkgo.go -> zkGo -> fib.wasm -> wasmi -> RiscV ELF -> risc0
4. `risc0(cuda)` fib_zkgo.go -> zkGo -> fib.wasm -> wasmi -> RiscV ELF -> risc0(cuda)
5. `tinygo` fib.go -> tinygo -> RiscV ELF -> risc0  (❌ due to not support currently)

### N=100
|         | zkWasm | risc0 | risc0(cuda) |
| ------- | ------ | ----- | ----------- |
| dryrun  | 0.72s  | ❌     | ❌           |
| witness | 81s    | 200s  | 200s        |
| prove   | ❌      | ⏳     | ⏳           |

### N=10000
|         | zkWasm | risc0 | risc0(cuda) |
| ------- | ------ | ----- | ----------- |
| dryrun  | 0.77s  | ❌     | ❌           |
| witness | 143.4s | 323s  | 323s        |
| prove   | ❌      | ⏳     | ⏳           |

### N=100000
|         | zkWasm | risc0 | risc0(cuda) |
| ------- | ------ | ----- | ----------- |
| dryrun  | 17s    | ❌     | ❌           |
| witness | ⏳      | ⏳     | ⏳           |
| prove   | ⏳      | ⏳     | ⏳           |

## fib.rs
Control Groups
1. `zkWasm` fib.rs -> fib.wasm -> zkWasm
2. `zkWasm(cuda)` fib.rs -> fib.wasm -> zkWasm(cuda)  (❌due to cuda 12.3 not compatible)
3. `risc0` fib.rs -> RiscV ELF -> risc0
4. `risc0(cuda)` fib.rs -> RiscV ELF -> risc0(cuda) 

### N=100
|         | zkWasm | risc0   | risc0(cuda) |
| ------- | ------ | ------- | ----------- |
| dryrun  | 8.79ms | ❌       | ❌           |
| witness | 33ms   | 14.27ms | 14.27ms     |
| prove   | 542s   | 6s      | 2s          |

### N=10000
|         | zkWasm | zkVM  | risc0(cuda) |
| ------- | ------ | ----- | ----------- |
| dryrun  | 148ms  | ❌     | ❌           |
| witness | 40s    | 0.54s | 0.54s       |
| prove   | ❌      | 25m   | 2.4m        |

### N=100000
|         | zkWasm | zkVM  | risc0(cuda) |
| ------- | ------ | ----- | ----------- |
| dryrun  | 11s    | ❌     | ❌           |
| witness | 🪫      | 49.9s | 49.9s       |
| prove   | ❌      | ⏳     | 235.1m      |

## Explain

❌ means cannot perform due to program error

⏳ means cannot perform due to too long execution time (usually longer than 2 hours)

🪫 means cannot perform due to OOM

### Test Enviroment

13700K 5.30 Ghz 16cores
64GB RAM
RTX 4090

`zkWasm-fibgo witness N=10000` and `zkWasm-fibrs N=100 prove` running on
AMD 5950X 3.4Ghz 16cores
128GB RAM

### Additional Info
1. tinygo is not [compatible](https://github.com/risc0/risc0/issues/1222) with latest zkvm
2. zkWasm prove failed because of panicked at `crates/zkwasm/src/circuits/utils/table_entry.rs:153:22`, maybe because of circuits size limit

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
cd third_party/risc0
git fetch --tags --all
git checkout v0.19.1
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

install wasm-pack
```
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
```

build zkGo
```
cd third_party/go/src
./all.bash
```

build zkWasm(optional)
```
cd third_party/zkWasm
cargo build --release
```

build risc0(optional)
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

# test zkwasm + fib.go
./zkwasm-fibgo.sh dry-run
./zkwasm-fibgo.sh single-prove

# test risc + fib.go
./risc0-fibgo.sh execute
./risc0-fibgo.sh prove

# test zkwasm + fib.rs
./zkwasm-fibrs.sh dry-run
./zkwasm-fibrs.sh single-prove

# test risc + fib.rs
./risc0-fibrs.sh execute
./risc0-fibrs.sh prove
```

**Open each shell, and you will find six commented commands. Execute each one for N=100, N=10000, and N=100000 to obtain the CPU/CUDA results.**

_If you encounter an error while running zkwasm, update the -k 22 argument to -k 24 and try again._

### cuda

Downlolad [CUDA tookit](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=runfile_local)
make sure your NVIDIA driver is installed and support latest CUDA toolkit
Run the `./cuda_xxx.run`

```
./cuda_xxx.run
export PATH=$PATH:/usr/local/cuda-12.3/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.3/lib64
```

**uncomment the cuda command in the shell and run the shell**

### tinygo

_due to lfs limit, you can contact me<jax@apus.network> for the tinygo deb and gzip_

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

the execution trace measurement instrction cycles grouth up by index(pow(N, 2))

### fib.go vs fib.rs

obviously, fib.rs is much faster than fib.go due to different memory management

### tinygo
tinygo is not ready for zkVM, we can work on it

### cuda
cuda accelarate is obvious, it shake-off the sha256，poseidon_hal，poseidon254_hal to GPU