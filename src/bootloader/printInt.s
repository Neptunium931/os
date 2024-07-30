.intel_syntax noprefix
.code16

printInt:
	xorw dx, dx
	movw ax, bx
	movw bx, 10000
	divw bx
	call printDigit
	movw bx, dx

	xorw dx, dx
	movw ax, bx
	movw bx, 1000
	divw bx
	call printDigit
	movw bx, dx

	xorw dx, dx
	movw ax, bx
	movw bx, 100
	divw bx
	call printDigit
	movw bx, dx

	xorw dx, dx
	movw ax, bx
	movw bx, 10
	divw bx
	call printDigit
	movw bx, dx

	movw ax, dx
	call printDigit
	ret

printDigit:
	mov ah, 0x0e
	add al, '0'
	int 0x10
	ret
