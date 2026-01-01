@echo off

set PATH=%~dp0..\dist\bin;%PATH%

echo Starting QEMU...

qemu-system-i386 -drive format=raw,file=..\src\peltOS.img

pause