#pragma once

#define KEY_UP 0x48
#define KEY_DOWN 0x50
#define KEY_LEFT 0x4B
#define KEY_RIGHT 0x4D

extern const char ascii_table[];
char command[256];
int cmd_ptr;
void check_scancode();