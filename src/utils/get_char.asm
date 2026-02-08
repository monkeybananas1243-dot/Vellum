[BITS 32]
[GLOBAL get_char]

get_char:
.wait_press:
    in al, 0x64
    test al, 1
    jz .wait_press

    in al, 0x60
    test al, 0x80
    jnz .wait_press

    ret