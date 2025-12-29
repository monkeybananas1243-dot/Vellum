[BITS 16]
[org 0x7c00]

KERNEL_OFFSET equ 0x1000

_start:
    ; 1. Immediately set up segments so memory addressing works
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; 2. Save the boot drive passed by BIOS in DL
    mov [BOOT_DRIVE], dl

    ; 3. Reset the disk controller (Good practice for hardware/older BIOS)
    xor ah, ah
    int 0x13
    jc disk_error

    ; 4. Load the Kernel from disk
    mov bx, KERNEL_OFFSET ; Destination: [ES:BX]
    mov ah, 0x02          ; BIOS read sector function
    mov al, 16            ; Number of sectors to read (Adjust to your kernel size)
    mov ch, 0x00          ; Cylinder 0
    mov dh, 0x00          ; Head 0
    mov cl, 0x02          ; Sector 2 (Sector 1 is the bootloader)
    mov dl, [BOOT_DRIVE]  ; The drive we booted from
    int 0x13
    jc disk_error         ; Jump if Carry Flag is set (error)

    ; 5. Switch to Protected Mode
    cli                   ; Clear interrupts
    
    ; Enable A20 Line via BIOS
    mov ax, 0x2401
    int 0x15

    lgdt [gdt_descriptor] ; Load GDT

    mov eax, cr0
    or eax, 0x1           ; Set PE (Protection Enable) bit in CR0
    mov cr0, eax

    jmp CODE_SEG:init_32  ; Far jump to flush CPU pipeline and enter 32-bit

disk_error:
    mov ah, 0x0e
    mov al, 'E'           ; Print 'E' for Error
    int 0x10
    jmp $

[BITS 32]
init_32:
    ; Update segment registers for 32-bit mode
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Setup stack safely away from the kernel
    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_OFFSET    ; Jump to your C/C++ kernel
    jmp $                 ; Hang if kernel returns

; --- Data Section ---

BOOT_DRIVE db 0

align 4
gdt_start:
    dq 0x0                ; Null descriptor
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

; Padding and Magic Number
times 510-($-$$) db 0
dw 0xAA55