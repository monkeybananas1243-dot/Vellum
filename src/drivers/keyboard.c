#include <keyboard.h>
#include <vga.h>
#include <get_char.h>
#include <io.h>

const char ascii_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\',
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
};

char command[256];
int cmd_ptr = 0;
unsigned char last_scancode = 0;

void check_scancode() {
    unsigned char scancode = get_char();

    if (scancode & 0x80) return;

    char letter = ascii_table[scancode];
    if (letter != 0) {
        if (letter == '\n') {
            command[cmd_ptr] = '\0';
            printk("\n");
            printk(command);
            printk("\n-># ");
            
            for(int i = 0; i < 256; i++) command[i] = 0;
            cmd_ptr = 0;
        }
        else if (cmd_ptr < 254) {
            printk_char(letter);
            command[cmd_ptr] = letter;
            cmd_ptr++;
            command[cmd_ptr] = '\0';
        }
    }

    while (!(inb(0x64) & 1) == 0) {
        if (inb(0x60) & 0x80) break;
    }
}