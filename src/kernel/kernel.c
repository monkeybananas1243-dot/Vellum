#include <io.h>
#include <get_char.h>
#include <keyboard.h>
#include <vga.h>

void main() 
{
    clear_screen();

    printk("  =========  =========  =          =========    =======    ========= \n");
    printk(" ||  __   |||  _____  || |        ||___   ___||  /  ___  \\  ||   ____||\n");
    printk(" || |__)  ||| |__     || |            || |    || |   | || ||  (___  \n");
    printk(" ||  ___/ |||  __|    || |            || |    || |   | ||  \\___  \\ \n");
    printk(" || |     ||| |____   || |____        || |    || |___| ||  ____)  ||\n");
    printk(" ||_|     |||_________|||_________|   ||_|     \\_______/  ||______/ ||\n");
    printk("  =========  =========  =========      ===      =======    ========= \n");
    
    
    printk("\n version 1.0 stable\n");
    printk("----------------------------------------------");
    printk("\n-># ");
    while(1) {check_scancode(); update_cursor(cursor_x, cursor_y);}
}
