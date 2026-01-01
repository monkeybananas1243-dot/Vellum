@echo off
setlocal enabledelayedexpansion
cd /d %~dp0..

set INC_PATH=%cd%\src\utils\include
set KERN_PATH=%cd%\src\kernel
set PATH=%cd%\dist\bin;%PATH%

set CC=i686-elf-gcc.exe
set AS=nasm.exe
set LD=i686-elf-ld.exe

set CFLAGS=-m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -I"%INC_PATH%" -I"%KERN_PATH%"
set LDFLAGS=-T linker.ld --oformat binary

if exist bin rd /s /q bin
mkdir bin\boot bin\kernel bin\utils

%AS% -f bin src/boot/boot.asm -o bin/boot/boot_sect.bin

set OBJS=bin/kernel/kernel_entry.o

for /r "src/kernel" %%f in (*.c) do (
    %CC% %CFLAGS% -c "%%f" -o "bin/kernel/%%~nf.o"
    set OBJS=!OBJS! bin/kernel/%%~nf.o
)

for /r "src/utils" %%f in (*.c) do (
    %CC% %CFLAGS% -c "%%f" -o "bin/utils/%%~nf.o"
    set OBJS=!OBJS! bin/utils/%%~nf.o
)

for /r "src/utils" %%f in (*.asm) do (
    %AS% -f elf32 "%%f" -o "bin/utils/%%~nf.o"
    set OBJS=!OBJS! bin/utils/%%~nf.o
)

echo.
echo Objects being linked: %OBJS%
echo.

%LD% %LDFLAGS% %OBJS% -o bin/kernel/kernel.bin

copy /y /b bin\boot\boot_sect.bin + bin\kernel\kernel.bin bin\peltOS.img
pause