extern void outb(unsigned short port, unsigned char val);
extern unsigned char get_char();

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_ADDRESS 0xB8000
#define WHITE_ON_BLACK 0x0F

int cursor_x = 0;
int cursor_y = 0;
int shell_limit = 4;

const char ascii_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\',
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
};

void update_cursor(int x, int y);
void clear_screen();
void k_print(char* str);
void k_putc(char c);
void scroll();
void check_scancode();

void main() {
    clear_screen();
    cursor_x = 0;
    cursor_y = 0;
    shell_limit = 4;

    k_print("  _____  ______ _       _______    ____   _____ \n");
    k_print(" |  __ \\|  ____| |      |__   __|  / __ \\ / ____|\n");
    k_print(" | |__) | |__  | |         | |    | |  | | (___  \n");
    k_print(" |  ___/|  __| | |         | |    | |  | |\\___ \\ \n");
    k_print(" | |    | |____| |____     | |    | |__| |____) |\n");
    k_print(" |_|    |______|______|    |_|     \\____/|_____/ \n");
    
    k_print("\n PELT OS v1.0\n");
    k_print("----------------------------------------------");
    k_print("\n-># ");

    while(1) {
        check_scancode();
    }
}

void update_cursor(int x, int y) {
    unsigned short pos = y * VGA_WIDTH + x;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char) ((pos >> 8) & 0xFF));
}

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

void k_putc(char c) {
    char* vga = (char*)VGA_ADDRESS;

    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c == '\b') {
        if (cursor_x > shell_limit || cursor_y > 0) {
            if (cursor_x > 0) {
                cursor_x--;
            } else if (cursor_y > 0) {
                cursor_y--;
                cursor_x = VGA_WIDTH - 1;
            }
            int offset = (cursor_y * VGA_WIDTH + cursor_x) * 2;
            vga[offset] = ' ';
            vga[offset + 1] = WHITE_ON_BLACK;
        }
    } else {
        int offset = (cursor_y * VGA_WIDTH + cursor_x) * 2;
        vga[offset] = c;
        vga[offset + 1] = WHITE_ON_BLACK;
        cursor_x++;
    }

    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
    }

    if (cursor_y >= VGA_HEIGHT) {
        scroll();
    }
    update_cursor(cursor_x, cursor_y);
}

void k_print(char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        k_putc(str[i]);
    }
}

void check_scancode() {
    unsigned char scancode = get_char();
    if (scancode & 0x80) return; 

    char letter = ascii_table[scancode];
    if (letter != 0) {
        k_putc(letter);
        if (letter == '\n') {
            k_print("-># ");
        }
    }
}