.intel_syntax noprefix
.code16

boot1:
	movw bx, OFFSET boot1Start
	call printString

# set up stack
movw sp, 0x1000

call getLowerMemory
movw bx, ax
call printInt

movw bx, OFFSET sapce
call printString

call getHigherMemory

call printInt

movw bx, OFFSET sapce
call printString

movw bx, ax
call printInt

	jmp $

boot1Start:
	.asciz "boot 1 started  "

sapce:
	.asciz " "

include:
	.include "src/bootloader/printStrnig.s"
	.include "src/bootloader/printInt.s"
	.include "src/bootloader/memory.s"
	.org     512*2
