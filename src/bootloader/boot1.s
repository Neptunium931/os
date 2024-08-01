.intel_syntax noprefix
.code16

boot1:
	movw bx, OFFSET boot1Start
	call printString

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

	movw bx, OFFSET sapce
	call printString

# enable A20
in   al, 0x92
or   al, 0x02
out  0x92, al
movw bx, OFFSET enableA20
call printString

	jmp protectMode

boot1Start:
	.asciz "boot 1 started  "

enableA20:
	.asciz "enable A20"

sapce:
	.asciz " "

helloFromProtectMode:
	.asciz "hello from protect mode"

include:
	.include "src/bootloader/printStrnig.s"
	.include "src/bootloader/printInt.s"
	.include "src/bootloader/memory.s"
	.include "src/bootloader/gdt.s"
	.include "src/bootloader/protectMode.s"

	.code32

_main32:
	movw ax, DATA_SEG
	movw ds, ax
	movw es, ax
	movw fs, ax
	movw gs, ax
	movw ss, ax

# set up stack
mov ebp, 0x90000
mov esp, ebp

end:
	jmp $

.org 512*2
