#include "../utils/include/io.h"
#include "../utils/include/get_char.h"
#include "../utils/include/keyboard.h"
#include "../utils/include/vga.h"

void main() {
    clear_screen();

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
        update_cursor(cursor_x, cursor_y);
    }
}