protectMode:
	cli
	lgdt [gdt_descriptor]
	mov  eax, cr0
	or   eax, 0x1
	mov  cr0, eax
	jmp  CODE_SEG:_main32
