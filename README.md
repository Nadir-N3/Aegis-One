# 🛡️ AEGIS‑ONE

![C](https://img.shields.io/badge/C-freestanding-1f6feb?logo=c&logoColor=white)
![Assembly](https://img.shields.io/badge/Assembly-ARM%20ASM-8b5cf6)
![ARM](https://img.shields.io/badge/Target-ARM%20(PL011%20UART%2C%20NEON)-0ea5e9)
![Build](https://img.shields.io/badge/Build-Makefile-informational)
![License](https://img.shields.io/badge/License-MIT%20LICENSE-22c55e)

**AEGIS‑ONE** adalah *bare‑metal starter* super ringan untuk ARM dengan:
- _boot stub_ ASM (`boot.S`) → set **stack**, **clear BSS**, panggil `kmain()`
- **UART PL011** minimal (polling) untuk debug (`uart.c/.h`)
- demo **SIMD NEON** (`neon_memxor.S`) untuk operasi XOR buffer
- **linker script** (`linker.ld`) dan **Makefile** siap pakai

> Cocok sebagai template sistem bare‑metal / firmware latihan: cepat boot, punya I/O serial, dan contoh optimisasi NEON.

---

## 📁 Struktur Proyek

```
AEGIS-ONE/
├─ LICENSE
├─ README.md
├─ Makefile
├─ linker.ld
├─ docs/
│  └─ ARCHITECTURE.md
└─ src/
   ├─ boot.S          # entry _start (ASM): set stack, clear BSS, call kmain
   ├─ kmain.c         # init UART + banner + demo NEON memxor
   ├─ uart.c          # driver UART PL011 minimal (polling)
   ├─ uart.h          # header UART
   └─ neon_memxor.S   # rutin SIMD NEON: XOR buffer (template optimisasi)
```

---

## ✨ Fitur
- **Boot minimal**: tidak ada runtime C standard; *freestanding*.
- **Serial debug**: PL011 (TX/RX polling) → `printf`‑like kecil bisa ditambahkan.
- **NEON demo**: contoh rutin XOR buffer dipanggil dari `kmain.c`.
- **Portabel**: alamat UART/entry/section dipetakan melalui `uart.h` & `linker.ld`.

---

## 🔧 Prasyarat
- Toolchain **cross‑compile ARM** (pilih sesuai target):
  - 32‑bit ARMv7‑A: `arm-none-eabi-gcc` / `binutils-arm-none-eabi`
  - 64‑bit ARMv8‑A (AArch64): `aarch64-none-elf-gcc` / `binutils-aarch64-elf`
- **make** & **objcopy**
- (Opsional) **QEMU** untuk uji cepat, atau papan fisik dengan PL011.

> Catatan: arsitektur tepat (ARMv7/AArch64) mengikuti setelan yang ada di Makefile & `boot.S`. Sesuaikan toolchain jika perlu.

---

## ⚙️ Konfigurasi Penting
- **`linker.ld`** → alamat **ROM/RAM**, section `.text/.rodata/.data/.bss`, entry symbol (`_start`)
- **`src/uart.h`** → **base address PL011** dan bit‑field register (samakan dengan SoC/board yang dipakai)
- **`Makefile`** → *cross prefix*, *CPU flags* (NEON), dan *output name*

Contoh flag umum :
```make
CROSS   ?= arm-none-eabi-
CFLAGS  += -ffreestanding -nostdlib -O2 -mcpu=cortex-a9 -mfpu=neon -mfloat-abi=hard
ASFLAGS += -mcpu=cortex-a9
LDFLAGS += -T linker.ld -nostdlib
```

---

## 🧱 Build
```bash
# install toolchain (contoh Debian/Ubuntu untuk 32-bit ARM)
sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi make

# clone dan build
git clone https://github.com/Nadir-N3/Aegis-One.git
cd Aegis-One
make
```
Hasil build biasanya berupa **ELF** dan **biner mentah** (lihat nama/output di Makefile).

> Jika toolchain kamu beda (AArch64), ganti prefix di Makefile atau export variabel yang disediakan (mis. `CROSS=aarch64-none-elf-`).

---

## ▶️ Boot & Serial
1. **Sesuaikan `UART_BASE`** di `src/uart.h` dengan alamat PL011 di board kamu.
2. Flash/Load biner ke board sesuai prosedur board (u‑boot, JTAG, sd‑boot, dsb.).
3. Hubungkan UART dan buka terminal (115200 8N1 atau sesuai setelan `uart.c`).  
   Saat boot kamu akan melihat **banner** dari `kmain.c` dan output demo NEON.

> Karena tiap SoC memiliki peta memori berbeda, pastikan `linker.ld` dan `UART_BASE` cocok dengan target hardware.

---

## 💡 Catatan NEON
`src/neon_memxor.S` adalah *template* rutin **XOR buffer** menggunakan NEON. Ini bisa dipakai untuk mempercepat operasi kriptografi / buffer ops. Modifikasi loop‑unroll, *alignment*, dan strategi tail‑bytes sesuai kebutuhan performa di SoC kamu.

---

## 🧪 Pengembangan
- Tambahkan *mini printf* untuk debug format string via UART.
- Embed **unit test kecil** yang menulis hasil ke serial.
- Buat *board header* terpisah kalau ingin mendukung beberapa papan dengan macro berbeda.
- Dokumentasikan alur boot di `docs/ARCHITECTURE.md` (sudah disediakan).

---

## 🛠️ Troubleshooting
- **Tidak ada output serial** → cek `UART_BASE`, clock UART, dan baudrate di `uart.c`.
- **Hang saat boot** → periksa stack pointer di `boot.S`, alamat entry, dan section mapping di `linker.ld`.
- **Instruksi NEON illegal** → pastikan CPU flags NEON aktif dan core mendukung NEON.
- **QEMU tidak cocok** → `-machine` harus cocok dengan PL011 yang tersedia; running di hardware nyata sering lebih mudah untuk pemula bare‑metal.

---

## 📜 Lisensi
Lihat berkas **LICENSE** di root repo.

---

## ✍️ Kredit
Dibuat oleh **Nadir‑N3** — [X](https://x.com/Naadiir_08) · [Instagram](https://instagram.com/__naadiir.fx)
