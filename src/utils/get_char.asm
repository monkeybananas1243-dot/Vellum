[BITS 32]
[GLOBAL get_char]
[GLOBAL check_scancode]

get_char:
.wait_ready:
    in al, 0x64
    and al, 1
    jz .wait_ready

    in al, 0x60
    
    push eax
    mov ecx, 0xFFFF
.delay:
    loop .delay
    pop eax
    ret

check_scancode:
    in al, 0x64
    and al, 1
    jz .no_key
    in al, 0x60
    ret
.no_key:
    xor al, al
    ret