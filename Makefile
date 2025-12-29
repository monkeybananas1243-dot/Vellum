AS = nasm
CC = i686-elf-gcc
LD = i686-elf-ld
QEMU = qemu-system-i386

IMAGE = peltOS.img
BOOT_BIN = boot/boot_sect.bin
KERNEL_BIN = kernel/kernel.bin

OBJS = kernel/entry.o \
       kernel/kernel.o \
       utils/get_char.o \
       utils/io.o

CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -nostdlib

all: $(IMAGE)

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMAGE)

$(BOOT_BIN): boot/boot.asm
	$(AS) -f bin $< -o $@

$(KERNEL_BIN): $(OBJS)
	$(LD) -T linker.ld $^ -o $@ --oformat binary

kernel/entry.o: kernel/entry.asm
	$(AS) -f elf32 $< -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

utils/%.o: utils/%.asm
	$(AS) -f elf32 $< -o $@

run: $(IMAGE)
	$(QEMU) -drive format=raw,file=$(IMAGE)

clean:
	rm -f $(BOOT_BIN) $(KERNEL_BIN) $(OBJS) $(IMAGE)