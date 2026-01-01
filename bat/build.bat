@echo off
setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
cd /d "%ROOT%"

set "INC_PATH=%ROOT%\src\utils\include"
set "PATH=%ROOT%\dist\bin;%PATH%"

set CC=i686-elf-gcc.exe
set AS=nasm.exe
set LD=i686-elf-ld.exe

set CFLAGS=-m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -I"%INC_PATH%"
set LDFLAGS=-T linker.ld --oformat binary

if exist bin rd /s /q bin
mkdir bin\boot bin\kernel bin\utils

%AS% -f elf32 src/kernel/kernel_entry.asm -o bin/kernel/kernel_entry.o
set OBJS=bin/kernel/kernel_entry.o

%AS% -f bin src/boot/boot.asm -o bin/boot/boot_sect.bin

for /r "src" %%f in (*.c) do (
    %CC% %CFLAGS% -c "%%f" -o "bin/utils/%%~nf_c.o"
    if !errorlevel! equ 0 (
        set OBJS=!OBJS! bin/utils/%%~nf_c.o
    ) else (
        echo Error compiling %%f
        pause
        exit /b
    )
)

for /r "src" %%f in (*.asm) do (
    if not "%%~nf"=="boot" if not "%%~nf"=="kernel_entry" (
        %AS% -f elf32 "%%f" -o "bin/utils/%%~nf_asm.o"
        if !errorlevel! equ 0 (
            set OBJS=!OBJS! bin/utils/%%~nf_asm.o
        ) else (
            echo Error compiling %%f
            pause
            exit /b
        )
    )
)

%LD% %LDFLAGS% %OBJS% -o bin/kernel/kernel.bin

if !errorlevel! equ 0 (
    copy /y /b bin\boot\boot_sect.bin + bin\kernel\kernel.bin bin\temp_system.bin
    
    fsutil file createnew bin\peltOS.img 1474560 >nul
    
    powershell -command "$os = [System.IO.File]::ReadAllBytes('bin\temp_system.bin'); $disk = [System.IO.File]::ReadAllBytes('bin\peltOS.img'); for($i=0; $i -lt $os.Length; $i++){ $disk[$i] = $os[$i] }; [System.IO.File]::WriteAllBytes('bin\peltOS.img', $disk)"
    
    del bin\temp_system.bin
    echo Build Successful: peltOS.img is now a standard 1.44MB floppy.
) else (
    echo Linker failed.
)

pause