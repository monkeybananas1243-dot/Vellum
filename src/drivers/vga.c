#include <vga.h>
#include <io.h>

int cursor_x = 0;
int cursor_y = 0;
int shell_limit = 4;

void scroll() {
    char* vga = (char*)VGA_ADDRESS;
    for (int i = 0; i < (VGA_HEIGHT - 1) * VGA_WIDTH * 2; i++) {
        vga[i] = vga[i + VGA_WIDTH * 2];
    }
    for (int i = (VGA_HEIGHT - 1) * VGA_WIDTH * 2; i < VGA_HEIGHT * VGA_WIDTH * 2; i += 2) {
        vga[i] = ' ';
        vga[i+1] = WHITE_ON_BLACK;
    }
    cursor_y = VGA_HEIGHT - 1;
}

void update_cursor() {
    unsigned short pos = (cursor_y * 80) + cursor_x;

    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char)(pos & 0xFF));

    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char)((pos >> 8) & 0xFF));
}

void clear_screen() {
    char* vga = (char*)VGA_ADDRESS;
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT * 2; i += 2) {
        vga[i] = ' ';
        vga[i+1] = WHITE_ON_BLACK;
    }
    cursor_x = 0;
    cursor_y = 0;
    update_cursor(cursor_x, cursor_y);
}

void printk_char(char c) {
    char* vga = (char*)VGA_ADDRESS;

    if (c == '\n') {cursor_x = 0; cursor_y++;}

    else if (c == '\b') {
        if (cursor_x > shell_limit && cursor_y > 0) {
            if (cursor_x > 0) {cursor_x--;}
            else if (cursor_y > 0) {cursor_y--; cursor_x = VGA_WIDTH - 1;}
            
            int offset = (cursor_y * VGA_WIDTH + cursor_x) * 2;
            vga[offset] = ' ';
            vga[offset + 1] = WHITE_ON_BLACK;
        }
    }

    else {
        int offset = (cursor_y * VGA_WIDTH + cursor_x) * 2;
        vga[offset] = c;
        vga[offset + 1] = WHITE_ON_BLACK;
        cursor_x++;
    }

    if (cursor_x >= VGA_WIDTH) {cursor_x = 0; cursor_y++;}

    if (cursor_y >= VGA_HEIGHT) {scroll();}

    update_cursor(cursor_x, cursor_y);
}

void printk(char* str) {
    for (int i = 0; str[i] != '\0'; i++) printk_char(str[i]);
}