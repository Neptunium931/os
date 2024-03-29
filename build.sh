#!/bin/env bash

nasm -felf32 boot.asm -o boot.o
# nasm -felf32 kernel.asm -o kernel.o

# i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
# i686-elf-gcc -T linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O0 -Wall -Wextra
i686-elf-gcc -T linker.ld -o kernel.bin -ffreestanding -O0 -nostdlib boot.o kernel.o -lgcc


if grub-file --is-x86-multiboot kernel.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi

# make iso
mkdir -p isodir/boot/grub
cp kernel.bin isodir/boot/kernel.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o os.iso isodir
