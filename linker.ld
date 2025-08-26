ENTRY(_start)

SECTIONS
{
  . = 0x40080000;

  .text : ALIGN(4096) {
    KEEP(*(.text._start))
    *(.text*)
  }

  .rodata : ALIGN(4096) { *(.rodata*) }
  .data   : ALIGN(4096) { *(.data*) }

  .bss (NOLOAD) : ALIGN(16) {
    __bss_start__ = .;
    *(.bss*)
    *(COMMON)
    __bss_end__ = .;
  }

  /DISCARD/ : { *(.comment) *(.note*) }
}
