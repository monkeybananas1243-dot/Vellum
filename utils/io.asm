[bits 32]

global outb
global inb

outb:
    mov edx, [esp + 4]    
    mov eax, [esp + 8]    
    out dx, al
    ret

inb:
    mov edx, [esp + 4]    
    xor eax, eax          
    in al, dx
    ret