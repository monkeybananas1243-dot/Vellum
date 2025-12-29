DIST_BIN = $(CURDIR)/../dist/bin/
AS = $(DIST_BIN)nasm
CC = $(DIST_BIN)i686-elf-gcc
LD = $(DIST_BIN)i686-elf-ld
QEMU = qemu-system-i386

IMAGE = peltOS.img
BOOT_BIN = boot/boot_sect.bin
KERNEL_BIN = kernel/kernel.bin

C_SOURCES = $(wildcard kernel/*.c utils/*.c)
ASM_SOURCES = $(wildcard utils/*.asm)

OBJ = ${C_SOURCES:.c=.o} ${ASM_SOURCES:.asm=.o}
OBJS_FINAL = kernel/kernel_entry.o $(filter-out kernel/kernel_entry.o, $(OBJ))

CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -nostdlib -Ikernel -Iutils/include

all: $(IMAGE)

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMAGE)
	truncate -s 32768 $(IMAGE)

$(BOOT_BIN): boot/boot.asm
	$(AS) -f bin $< -o $@

$(KERNEL_BIN): $(OBJS_FINAL)
	$(LD) -T linker.ld $^ -o $@ --oformat binary

kernel/kernel_entry.o: kernel/kernel_entry.asm
	$(AS) -f elf32 $< -o $@

kernel/%.o: kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

utils/%.o: utils/%.c
	$(CC) $(CFLAGS) -c $< -o $@

utils/%.o: utils/%.asm
	$(AS) -f elf32 $< -o $@

clean:
	rm -rf $(BOOT_BIN) $(KERNEL_BIN) $(IMAGE)
	find . -name "*.o" -type f -delete