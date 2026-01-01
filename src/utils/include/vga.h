#pragma once

extern int cursor_x;
extern int cursor_y;

void scroll();
void update_cursor();
void clear_screen();
void printk_char(char c);
void printk();