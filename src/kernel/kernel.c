#include <io.h>
#include <get_char.h>
#include <keyboard.h>
#include <vga.h>

void main() {
    clear_screen();

    printk("  _____  ______ _       _______    ____   _____ \n");
    printk(" |  __ \\|  ____| |      |__   __|  / __ \\ / ____|\n");
    printk(" | |__) | |__  | |         | |    | |  | | (___  \n");
    printk(" |  ___/|  __| | |         | |    | |  | |\\___ \\ \n");
    printk(" | |    | |____| |____     | |    | |__| |____) |\n");
    printk(" |_|    |______|______|    |_|     \\____/|_____/ \n");
    
    printk("\n PELT OS v1.0\n");
    printk("----------------------------------------------");
    printk("\n-># ");
    while(1) {
        check_scancode();
        update_cursor(cursor_x, cursor_y);
    }
}