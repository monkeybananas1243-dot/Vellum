@echo off
setlocal enabledelayedexpansion

set PATH=%~dp0..\dist\bin;%PATH%

set CC=i686-elf-gcc.exe
set AS=nasm.exe
set LD=i686-elf-ld.exe

set CFLAGS=-m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -I../utils/include -I../kernel
set LDFLAGS=-T ..\linker.ld --oformat binary

echo Cleaning old files...
del ..\boot\*.bin ..\kernel\*.o ..\kernel\*.bin ..\utils\*.o ..\peltOS.img 2>nul

echo Assembling Bootloader...
%AS% -f bin ..\boot\boot.asm -o ..\boot\boot_sect.bin

echo Compiling Kernel Entry...
set OBJS=..\kernel\kernel_entry.o
%AS% -f elf32 ..\kernel\kernel_entry.asm -o ..\kernel\kernel_entry.o

echo Compiling C files in Kernel...
for /r "..\kernel" %%f in (*.c) do (
    echo Compiling %%~nxf
    %CC% %CFLAGS% -c "%%f" -o "%%~dpnf.o"
    set OBJS=!OBJS! "%%~dpnf.o"
)

echo Compiling C files in Utils...
for /r "..\utils" %%f in (*.c) do (
    echo Compiling %%~nxf
    %CC% %CFLAGS% -c "%%f" -o "%%~dpnf.o"
    set OBJS=!OBJS! "%%~dpnf.o"
)

echo Assembling ASM files in Utils...
for /r "..\utils" %%f in (*.asm) do (
    echo Assembling %%~nxf
    %AS% -f elf32 "%%f" -o "%%~dpnf.o"
    set OBJS=!OBJS! "%%~dpnf.o"
)

echo Linking Kernel...
%LD% %LDFLAGS% %OBJS% -o ..\kernel\kernel.bin

echo Creating OS Image...
copy /y /b ..\boot\boot_sect.bin + ..\kernel\kernel.bin ..\peltOS.img

fsutil file createnew padding.bin 32768 >nul
copy /b ..\peltOS.img + padding.bin ..\peltOS.img >nul
del padding.bin

echo Done!
pause