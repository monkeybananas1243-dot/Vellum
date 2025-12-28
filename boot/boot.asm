[BITS 16]
[org 0x7c00]

KERNEL_OFFSET equ 0x7E00

_start:
    mov [BOOT_DRIVE], dl

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov bx, KERNEL_OFFSET
    mov ah, 0x02
    mov al, 32
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc disk_error

    cli
    mov ax, 0x2401
    int 0x15
    
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_32

disk_error:
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    jmp $

[BITS 32]
init_32:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_OFFSET
    jmp $

BOOT_DRIVE db 0

align 4
gdt_start:
    dq 0x0
gdt_code:
    dw 0xffff, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
gdt_data:
    dw 0xffff, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510-($-$$) db 0
dw 0xAA55