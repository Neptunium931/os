.intel_syntax noprefix
.code16

boot1:
	movw bx, OFFSET boot1Start
	call printString

# set up stack
movw sp, 0x1000

	jmp $

boot1Start:
	.asciz "boot 1 started"

	.include "src/bootloader/printStrnig.s"
	.org     512*2
