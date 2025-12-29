@echo off

set PATH=%~dp0..\dist\bin;%PATH%

qemu-system-i386 -drive format=raw,file=../peltOS.img

pause