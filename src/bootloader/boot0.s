.intel_syntax noprefix
.code16
.text
.globl _start

_start:

	movb al, 'H'
	movb ah, 0x0e
	int  0x10

	jmp 0x1000

	.     = _start + 510      #mov to 510th byte from 0 pos
	.byte 0x55            #append boot signature
	.byte 0xaa            #append boot signature
