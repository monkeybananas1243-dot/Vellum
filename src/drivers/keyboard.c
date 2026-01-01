#include <keyboard.h>
#include <keyboard.h>
#include <keyboard.h>

const char ascii_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\',
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
};

void check_scancode() {
    unsigned char scancode = get_char();
    
    if (scancode & 0x80) return;

    if (scancode == KEY_UP && cursor_y > 0) {cursor_y--;}
    else if (scancode == KEY_DOWN && cursor_y < VGA_HEIGHT - 1) {cursor_y++;}
    else if (scancode == KEY_LEFT && cursor_x > 0) {cursor_x--;}
    else if (scancode == KEY_RIGHT && cursor_x < VGA_WIDTH - 1) {cursor_x++;}

    else {
        char letter = ascii_table[scancode];
        if (letter != 0) {
            printk_char(letter);
            if (letter == '\n') {
                printk("-># ");
            }
            return; 
        }
    }
    update_cursor(cursor_x, cursor_y);
}