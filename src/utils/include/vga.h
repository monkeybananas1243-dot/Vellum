#pragma once

extern int cursor_x;
extern int cursor_y;

#define VGA_ADDRESS 0xB8000

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define WHITE_ON_BLACK 0x0F

void scroll();
void update_cursor();
void clear_screen();
void printk_char(char c);
void printk();