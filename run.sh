#!/bin/env bash

set -e

printf_line() {
	line=$@
	printf "%s " ${line[@]}
	printf '\n'
}

runFloppy="qemu-system-x86_64 -drive file=src/floppy.img,index=0,if=floppy,format=raw -m 512M"
printf_line $runFloppy
$($runFloppy)
