AS=i686-elf-as
CC=i686-elf-gcc
LD=i686-elf-ld
OBJCOPY=i686-elf-objcopy
OBJDUMP=i686-elf-objdump
STRIP=i686-elf-strip
RM=rm

all: floppy

build:
	$(MAKE) -C src AS=$(AS) CC=$(CC) LD=$(LD) OBJCOPY=$(OBJCOPY) OBJDUMP=$(OBJDUMP) STRIP=$(STRIP)

floppy: build
	dd if=/dev/zero of=src/floppy.img bs=512 count=2880
	dd if=./src/bootloader/boot0.bin of=src/floppy.img bs=512 count=1 conv=notrunc
	dd if=./src/bootloader/boot1.bin of=src/floppy.img bs=512 count=1 seek=1 conv=notrunc

run: all
	qemu-system-x86_64 \
	-drive file=src/floppy.img,index=0,if=floppy,format=raw \
	-m 512M

debug: all
	bochs -f bochs_config

clean:
	$(RM) -f src/floppy.img
	find . -type f -name "*.o" -exec $(RM) {} \;
	find . -type f -name "*.bin" -exec $(RM) {} \;

.PHONY: all run debug
