#!/bin/env bash

set -e

printf_line() {
	line=$@
	printf "%s " ${line[@]}
	printf '\n'
}

buildBoot0="i686-elf-as src/bootloader/boot0.s -o src/bootloader/boot0.o"
printf_line $buildBoot0
$($buildBoot0)

linkBoot0="i686-elf-ld -Ttext 0x7c00 -o src/bootloader/boot0.bin src/bootloader/boot0.o --oformat binary"
printf_line $linkBoot0
$($linkBoot0)

buildBoot1="i686-elf-as src/bootloader/boot1.s -o src/bootloader/boot1.o"
printf_line $buildBoot1
$($buildBoot1)

linkBoot1="i686-elf-ld -Ttext 0x1000 -o src/bootloader/boot1.bin src/bootloader/boot1.o --oformat binary"
printf_line $linkBoot1
$($linkBoot1)

buildFlopy="dd if=/dev/zero of=src/floppy.img bs=512 count=2880"
printf_line $buildFlopy
$($buildFlopy)

burnBoot0="dd if=src/bootloader/boot0.bin of=src/floppy.img bs=512 seek=0"
printf_line $burnBoot0
$($burnBoot0)

burnBoot1="dd if=src/bootloader/boot1.bin of=src/floppy.img bs=512 seek=1"
printf_line $burnBoot1
$($burnBoot1)
