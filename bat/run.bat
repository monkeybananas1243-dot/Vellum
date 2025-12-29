@echo off
call bat\env.bat
qemu-system-i386 -drive format=raw,file=../peltOS.img