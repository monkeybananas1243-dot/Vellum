@echo off
del boot\*.o boot\*.bin kernel\*.o utils\*.o peltOS.img 2>nul

nasm -f bin boot/boot.asm -o boot/boot_sect.bin

nasm -f elf32 utils/get_char.asm -o utils/get_char.o
nasm -f elf32 utils/io.asm -o utils/io.o

%TOOLPATH%\i686-elf-gcc.exe -m32 -ffreestanding -fno-asynchronous-unwind-tables -c kernel/kernel.c -o kernel/kernel.o

%TOOLPATH%\i686-elf-ld.exe -T linker.ld kernel/kernel.o utils/get_char.o utils/io.o -o kernel/kernel.bin --oformat binary

copy /b boot\boot_sect.bin + kernel\kernel.bin peltOS.img

fsutil file createnew padding.bin 1474560
copy /b peltOS.img + padding.bin peltOS.img
del padding.bin