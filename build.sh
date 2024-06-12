#!/bin/env bash

set -e

grupVersion() {
	if command -v grub-file >/dev/null 2>&1; then
		echo "grub"
	elif command -v grub2-file >/dev/null 2>&1; then
		echo "grub2"
	fi
}

printf_line() {
	line=$@
	printf "%s " ${line[@]}
	printf '\n'
}

build_kernel_bin() {
	build_boot="i686-elf-as  ./src/boot/x86/boot.s -o boot.o"
	printf_line $build_boot
	$($build_boot)

	build_kernel="i686-elf-gcc -c ./src/kernel/kernel.c -o kernel.o -std=c99 -ffreestanding -O2 -Wall -Wextra"
	printf_line $build_kernel
	$($build_kernel)

	linkerKernel="i686-elf-gcc -T linker.ld -o kernel.bin -ffreestanding -O0 -nostdlib boot.o kernel.o"
	printf_line $linkerKernel
	$($linkerKernel)
}

make_iso() {
	create_dir="mkdir -p isodir/boot/grub"
	printf_line $create_dir
	$($create_dir)

	copy_kernel="cp kernel.bin isodir/boot/"
	printf_line $copy_kernel
	$($copy_kernel)

	copy_grub="cp grub.cfg isodir/boot/grub"
	printf_line $copy_grub
	$($copy_grub)

	create_iso=$grub"-mkrescue -o os.iso isodir"
	printf_line $create_iso
	$($create_iso)
}

all() {
	build_kernel_bin

	if $grub-file --is-x86-multiboot kernel.bin; then
		printf_line "multiboot confirmed"
	else
		printf_line "the file is not multiboot"
		exit 1
	fi

	make_iso
}

clean() {
	clean_iso="rm -f os.iso"
	printf_line $clean_iso
	$($clean_iso)
}

mrpoper() {
	clean

	clean_kernel="rm -f kernel.bin"
	printf_line $clean_kernel
	$($clean_kernel)

	clean_obj="rm -f *.o"
	printf_line $clean_obj
	$($clean_obj)

	clean_dir="rm -rf isodir"
	printf_line $clean_dir
	$($clean_dir)
}

commands() {
	venv/bin/intercept-build ./build.sh all
}

grub=$(grupVersion)

if [[ $1 = "clean" ]]; then
	clean
elif [[ $1 = "mrpoper" ]]; then
	mrpoper
elif [[ $1 = "all" ]]; then
	all
elif [[ $1 = "" ]]; then
	all
elif [[ $1 = "build" ]]; then
	build_kernel_bin
elif [[ $1 = "commands" ]]; then
	commands
else
	printf "invalid argument"
	exit 1
fi
