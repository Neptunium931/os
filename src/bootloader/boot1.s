.intel_syntax noprefix
.code16

boot1:
	movw bx, OFFSET boot1Start
	call printString

# set up stack
movw sp, 0x1000

movw bx, 1234
call printInt

	jmp $

boot1Start:
	.asciz "boot 1 started  "

include:
	.include "src/bootloader/printStrnig.s"
	.include "src/bootloader/printInt.s"
	.org     512*2
