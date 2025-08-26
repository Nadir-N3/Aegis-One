.section .text._start
.global _start
.type _start,%function

.extern __bss_start__
.extern __bss_end__
.extern kmain

_start:
    // Set up stack
    adrp    x0, _stack_top
    add     x0, x0, :lo12:_stack_top
    mov     sp, x0

    // Clear BSS
    adrp    x1, __bss_start__
    add     x1, x1, :lo12:__bss_start__
    adrp    x2, __bss_end__
    add     x2, x2, :lo12:__bss_end__
    mov     x3, #0
1:
    cmp     x1, x2
    b.hs    2f
    str     x3, [x1], #8
    b       1b
2:
    // Jump to C
    bl      kmain

hang:
    wfe
    b       hang

.size _start, .-_start

// Simple static stack in BSS
.section .bss
.align 12                      // 4KB align
.global _stack
_stack:
    .skip 0x4000               // 16KB stack
.global _stack_top
_stack_top:
