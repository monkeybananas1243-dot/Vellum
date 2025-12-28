@echo off
set TOOLPATH=C:\i686-elf-tools-windows\bin

del boot\*.o boot\*.bin kernel\*.o utils\*.o 2>nul

nasm -f bin boot/boot.asm -o boot/boot_sect.bin

nasm -f elf32 utils/get_char.asm -o utils/get_char.o
nasm -f elf32 utils/io.asm -o utils/io.o

%TOOLPATH%\i686-elf-gcc.exe -m32 -ffreestanding -fno-asynchronous-unwind-tables -c kernel/kernel.c -o kernel/kernel.o

%TOOLPATH%\i686-elf-ld.exe -T linker.ld kernel/kernel.o utils/get_char.o utils/io.o -o kernel/kernel.bin --oformat binary

copy /b boot\boot_sect.bin + kernel\kernel.bin boot\boot.bin

qemu-system-i386 -drive format=raw,file=boot/boot.bin
pause