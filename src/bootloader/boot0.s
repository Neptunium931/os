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

cmpb al, 0x02
jne  display_error

movb al, 'R'
movb ah, 0x0e
int  0x10

	jmp 0x1000

display_error:
	movb al, 'E'
	movb ah, 0x0e
	int  0x10

	.org  510
	.byte 0x55            #append boot signature
	.byte 0xaa            #append boot signature
