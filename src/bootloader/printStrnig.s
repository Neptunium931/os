.intel_syntax noprefix
.code16

printString:
	mov ah, 0x0e

printString_loop:
	mov al, [bx]
	cmp al, 0
	je  printString_done
	int 0x10
	inc bx
	jmp printString_loop

printString_done:
	ret
