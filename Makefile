
CC = i686-elf-gcc
AS = nasm
LD = i686-elf-ld

CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib \
         -Isrc/utils/include -Isrc/kernel
LDFLAGS = -T linker.ld --oformat binary

C_SOURCES = $(wildcard src/kernel/*.c src/utils/*.c)
ASM_SOURCES = $(wildcard src/utils/*.asm)
OBJ = bin/kernel/kernel_entry.o $(C_SOURCES:src/%.c=bin/%.o) $(ASM_SOURCES:src/%.asm=bin/%.o)

all: bin/peltOS.img

bin/peltOS.img: bin/boot/boot_sect.bin bin/kernel/kernel.bin
	cat $^ > $@

bin/boot/boot_sect.bin: src/boot/boot.asm
	@mkdir -p bin/boot
	$(AS) -f bin $< -o $@

bin/kernel/kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

bin/kernel/kernel_entry.o: src/kernel/kernel_entry.asm
	@mkdir -p bin/kernel
	$(AS) -f elf32 $< -o $@

bin/utils/%.o: src/utils/%.asm
	@mkdir -p bin/utils
	$(AS) -f elf32 $< -o $@

bin/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf bin/*.bin bin/*.o bin/*.img bin/boot bin/kernel bin/utils