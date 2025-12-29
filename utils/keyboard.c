#include "vga.h"
#include "get_char.h"
#include "keyboard.h"

const char ascii_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\',
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
};

void check_scancode() {
    unsigned char scancode = get_char();
    
    if (scancode & 0x80) return; 

    if (scancode == KEY_UP) {if (cursor_y > 0) cursor_y--;}
    else if (scancode == KEY_DOWN) {if (cursor_y < VGA_HEIGHT - 1) cursor_y++;}
    else if (scancode == KEY_LEFT) {if (cursor_x > 0) cursor_x--;}
    else if (scancode == KEY_RIGHT) {if (cursor_x < VGA_WIDTH - 1) cursor_x++;}
    else {
        char letter = ascii_table[scancode];
        if (letter != 0) {
            k_putc(letter);
            if (letter == '\n') {
                k_print("-># ");
            }
            return; 
        }
    }

    update_cursor(cursor_x, cursor_y);
}