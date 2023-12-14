package main

import "math/big"

//go:wasmimport env wasm_input
//go:noescape
func wasm_input(isPublic uint32) uint64

//go:wasmimport env require
//go:noescape
func require(uint32)

func main() {
	var a0, a1 *big.Int
	a0 = big.NewInt(0)
	a1 = big.NewInt(1)
	for i := 2; i <= 100000; i++ {
		a0, a1 = a1, a0.Add(a0, a1)
	}
	modResult := a1.Mod(a1, big.NewInt(1<<32))
	an := wasm_input(1)
	if an != modResult.Uint64() {
		require(0)
	}
}
