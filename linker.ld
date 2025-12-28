ENTRY(_start)

SECTIONS
{
    . = 0x7E00;

    .text : {
        kernel/kernel.o(.text._start)
        kernel/kernel.o(.text)
        *(.text)
    }

    .rodata : { *(.rodata*) }
    .data   : { *(.data) }
    
    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }

    .bss : {
        *(.bss)
        *(COMMON)
    }

    . = ALIGN(512);
    .padding : {
        FILL(0x00);
        . = 16384;
        BYTE(0x00);
    }
}