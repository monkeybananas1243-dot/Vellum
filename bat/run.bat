@echo off

cd /d "%~dp0"

call env.bat

qemu-system-i386 -drive format=raw,file=..\peltOS.img