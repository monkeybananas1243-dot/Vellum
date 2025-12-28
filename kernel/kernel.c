extern void outb(unsigned short port, unsigned char val);
extern unsigned char get_char();

int cursor_x = 0;
int cursor_y = 0;
int shell_limit;

const char ascii_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\',
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
};

void update_cursor(int x, int y);
void clear_screen();
void k_print(char* str);
void main();

void _start() {
    main();
}

void main() {
    cursor_x = 0;
    cursor_y = 0;
    shell_limit = 4;

    clear_screen();

    k_print("  _____  ______ _       _______    ____   _____ \n");
    k_print(" |  __ \\|  ____| |      |__   __|  / __ \\ / ____|\n");
    k_print(" | |__) | |__  | |         | |    | |  | | (___  \n");
    k_print(" |  ___/|  __| | |         | |    | |  | |\\___ \\ \n");
    k_print(" | |    | |____| |____     | |    | |__| |____) |\n");
    k_print(" |_|    |______|______|    |_|     \\____/|_____/ \n");
    
    k_print("\n PELT OS v1.0\n");
    k_print("----------------------------------------------\n");
    k_print("-># ");

    while(1) {
        unsigned char scancode = get_char();
        
        if (scancode < 0x80) {
            if (scancode == 0x4B) { // LEFT
                if (cursor_x > shell_limit) cursor_x--;
            } 
            else if (scancode == 0x4D) { // RIGHT
                if (cursor_x < 79) cursor_x++;
            }
            else {
                char letter = ascii_table[scancode];
                if (letter == '\n') {
                    k_print("\n-># ");
                } 
                else if (letter != 0) {
                    char str[2] = {letter, '\0'};
                    k_print(str);
                }
            }
        }
        update_cursor(cursor_x, cursor_y);
    }
}

void update_cursor(int x, int y) {
    unsigned short pos = y * 80 + x;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char) ((pos >> 8) & 0xFF));
}

void clear_screen() {
    char* vga = (char*)0xB8000;
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        vga[i] = ' ';
        vga[i+1] = 0x0F;
    }
}

void k_print(char* str) {
    char* vga = (char*)0xB8000;
    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == '\n') {
            cursor_x = 0;
            cursor_y++;
        }
        else if (str[i] == '\b') {
            if (cursor_x > shell_limit) {
                cursor_x--;
                int offset = (cursor_y * 80 + cursor_x) * 2;
                vga[offset] = ' ';
                vga[offset + 1] = 0x0F;
            }
        } 
        else {
            int offset = (cursor_y * 80 + cursor_x) * 2;
            vga[offset] = str[i];
            vga[offset + 1] = 0x0F;
            cursor_x++;
        }

        if (cursor_x >= 80) {
            cursor_x = 0;
            cursor_y++;
        }

        if (cursor_y >= 25) {
            clear_screen();
            cursor_y = 0;
            cursor_x = 0;
        }
    }
    update_cursor(cursor_x, cursor_y);
}