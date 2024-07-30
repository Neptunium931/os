.intel_syntax noprefix
.code16
.text
.globl _start

_start:
# disable interrupts
cli

# set up segments registers
movw ax, 0x0000
movw ds, ax
movw es, ax
movw fs, ax
movw gs, ax
movw ss, ax

# set up stack
movw sp, 0x7c00

# enable interrupts
sti

# set video mode
xorb ah, ah
movb al, 0x3 # 80x25 text mode
int  0x10

# reset floppy controller
movb ah, 0x0000
int  0x13

# read boot1
movw bx, 0x1000
movb ah, 0x02
movb dl, 0x00
movb dh, 0x00
movb ch, 0x00
movb cl, 0x02
movb al, 0x02
int  0x13

cmpb al, 0x01
jne  error_floppy

movw bx, OFFSET stringBoot1Load
call printString

	jmp 0x1000
	jmp freeze

error_floppy:
	movb ah, 0x01
	int  0x13
	xorb bh, bh
	movb bl, ah
	call printInt
	jmp  display_error

display_error:
	movw bx, OFFSET stringErrorReadingBoot1
	call printString
	jmp  freeze

freeze:
	jmp $

stringBoot1Load:
	.asciz "boot 1 loaded  "

stringErrorReadingBoot1:
	.asciz " error reading boot1 "

include:
	.include "src/bootloader/printStrnig.s"
	.include "src/bootloader/printInt.s"

	.org  510
	.byte 0x55            #append boot signature
	.byte 0xaa            #append boot signature
