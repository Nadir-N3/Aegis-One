# AEGIS ONE – Arsitektur Teknis

## Tujuan
Menyediakan fondasi **assembly‑first** yang elegan untuk:
- Riset kernel/crypto tingkat lanjut.
- Prototyping secure wallet/enclave bergaya HSM.
- Porting ke SoC ARMv8 lain dengan effort minimal.

## Layer
1. **Boot & Init (ASM)** — set stack, bersihkan BSS, panggil `kmain`.
2. **Board Support (C)** — UART PL011, timer (WIP), GIC (WIP).
3. **Primitif SIMD (ASM/NEON)** — pola optimisasi vektor (contoh memxor).
4. **Kernel Services (C/Rust)** — mem, scheduler, IPC, drivers.

## Pemetaan Perangkat (QEMU virt)
- UART0 (PL011): `0x0900_0000`  
- GICv2, timer, dan perangkat lain mengikuti layout QEMU (akan dilengkapi bertahap).

## Build & Link
- `linker.ld` menempatkan image pada alamat tinggi (0x4008_0000) kompatibel dengan mode `-kernel` QEMU.
- Entry `_start` berada di awal `.text` (KEEP) agar PC lompat tepat ke ASM bootstrap.

## Roadmap Teknis
- EL2/EL3 bring‑up opsional, MMU on, page tables 4K, exception vector table, trap‑&‑emulate minimal.
- Crypto inner‑loops di ASM (NEON) dengan fallback C dan self‑tests.
