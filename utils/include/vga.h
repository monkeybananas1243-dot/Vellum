#pragma once

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_ADDRESS 0xB8000
#define WHITE_ON_BLACK 0x0F

extern int cursor_x;
extern int cursor_y;
extern int shell_limit;

void update_cursor(int x, int y);
void clear_screen();
void k_putc(char c);
void k_print(char* str);
void scroll();