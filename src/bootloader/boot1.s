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

_main32:
	.code32
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov esp, 0x90000

	mov WORD PTR [0xb8000], 'P'
	mov WORD PTR [0xb8001], 0x07

	jmp $
