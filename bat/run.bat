@echo off

set "ROOT=%~dp0.."
cd /d "%ROOT%"

qemu-system-i386 -boot a -fda bin/peltOS.img

pause