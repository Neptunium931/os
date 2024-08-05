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
	nop
	nop
	nop
	nop
	nop
	nop
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax

	mov esp, 0x90000

	mov WORD PTR [0xB8000], 'P'
	mov WORD PTR [0xB8001], 0x1B

end:
	jmp end

.org 512*2
