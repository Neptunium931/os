protectMode:
	cli
	xor ax, ax
	mov ds, ax

	lgdtd [gdt_descriptor]

	mov eax, cr0
	or  eax, 0x1
	mov cr0, eax

	jmp CODE_SEG:_main32
