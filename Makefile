# AEGIS ONE build system
CROSS ?= aarch64-none-elf

CC      := $(CROSS)-gcc
AS      := $(CROSS)-gcc
OBJCOPY := $(CROSS)-objcopy

CFLAGS  := -O2 -ffreestanding -nostdlib -nostartfiles -fno-builtin \
           -Wall -Wextra -Wno-unused-parameter -mcpu=cortex-a53
LDFLAGS := -T linker.ld -nostdlib

SRC_C := src/kmain.c src/uart.c
SRC_S := src/boot.S src/neon_memxor.S
OBJ   := $(patsubst src/%.c,build/%.o,$(SRC_C)) \
         $(patsubst src/%.S,build/%.o,$(SRC_S))

all: build/kernel.elf

build:
\tmkdir -p build

build/%.o: src/%.c | build
\t$(CC) $(CFLAGS) -c $< -o $@

build/%.o: src/%.S | build
\t$(AS) $(CFLAGS) -c $< -o $@

build/kernel.elf: $(OBJ) linker.ld
\t$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)

run: all
\tqemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -kernel build/kernel.elf

clean:
\trm -rf build
