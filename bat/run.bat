@echo off

set "ROOT=%~dp0.."
cd /d "%ROOT%"

qemu-system-i386 -boot a -drive file=bin/peltOS.img,format=raw,if=floppy

pause