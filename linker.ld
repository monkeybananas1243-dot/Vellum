ENTRY(_start)
SECTIONS
{
    . = 0x1000;
    .text : {
        bin/kernel/kernel_entry.o(.text)
        *(.text)
    }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss  : { *(.bss) }

}