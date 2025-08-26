#include <stdint.h>
#include "uart.h"

extern void memxor_neon(uint8_t *dst, const uint8_t *src, unsigned long n);

static void banner(void) {
    uart_puts("\nAEGIS-ONE: Boot OK\n");
}

void kmain(void) {
    uart_init();
    banner();

    // Demo: NEON memxor (32 bytes)
    uint8_t a[32];
    uint8_t b[32];
    for (int i=0;i<32;i++){ a[i] = (uint8_t)i; b[i] = 0xAA; }

    memxor_neon(a, b, 32);

    uart_puts("memxor done (32 bytes)\n");
    uart_puts("a = ");
    for (int i=0;i<32;i++){ uart_hex8(a[i]); uart_putc(' '); }
    uart_puts("\n");
    // loop forever handled by ASM after return
}
