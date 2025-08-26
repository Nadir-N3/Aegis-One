#include <stdint.h>
#include "uart.h"

#define UART0_BASE 0x09000000UL

#define UART_DR   0x00
#define UART_FR   0x18
#define UART_IBRD 0x24
#define UART_FBRD 0x28
#define UART_LCRH 0x2C
#define UART_CR   0x30
#define UART_IMSC 0x38

static inline void mmio_write(uint64_t reg, uint32_t val) {
    *(volatile uint32_t *)(reg) = val;
}
static inline uint32_t mmio_read(uint64_t reg) {
    return *(volatile uint32_t *)(reg);
}

void uart_init(void) {
    // Disable UART
    mmio_write(UART0_BASE + UART_CR, 0x00000000);

    // Minimal init: 8N1, FIFO enable
    mmio_write(UART0_BASE + UART_LCRH, (1<<4) | (3<<5)); // FEN | WLEN=8

    // Enable UART TX/RX and UART overall
    mmio_write(UART0_BASE + UART_CR, (1<<9) | (1<<8) | (1<<0)); // TXE | RXE | UARTEN
}

void uart_putc(char c) {
    // Wait while TX FIFO full
    while (mmio_read(UART0_BASE + UART_FR) & (1<<5)) { }
    mmio_write(UART0_BASE + UART_DR, (uint32_t)c);
}

void uart_puts(const char *s) {
    while (*s) {
        if (*s == '\n') uart_putc('\r');
        uart_putc(*s++);
    }
}

void uart_hex8(uint8_t v) {
    static const char* HEX = "0123456789ABCDEF";
    uart_putc(HEX[(v >> 4) & 0xF]);
    uart_putc(HEX[v & 0xF]);
}
