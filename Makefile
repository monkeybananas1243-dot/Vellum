DIST_BIN = $(CURDIR)/../dist/bin/
AS = $(DIST_BIN)nasm
CC = $(DIST_BIN)i686-elf-gcc
LD = $(DIST_BIN)i686-elf-ld
QEMU = qemu-system-i386

IMAGE = peltOS.img
BOOT_BIN = boot/boot_sect.bin
KERNEL_BIN = kernel/kernel.bin

OBJS = kernel/kernel_entry.o \
       kernel/kernel.o \
       utils/get_char.o \
       utils/io.o

CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -nostdlib

all: $(IMAGE)

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMAGE)
	truncate -s 32768 $(IMAGE)

$(BOOT_BIN): boot/boot.asm
	$(AS) -f bin $< -o $@

$(KERNEL_BIN): $(OBJS)
	$(LD) -T linker.ld $^ -o $@ --oformat binary

kernel/kernel_entry.o: kernel/kernel_entry.asm
	$(AS) -f elf32 $< -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

utils/%.o: utils/%.asm
	$(AS) -f elf32 $< -o $@

clean:
	rm -f $(BOOT_BIN) $(KERNEL_BIN) $(OBJS) $(IMAGE)