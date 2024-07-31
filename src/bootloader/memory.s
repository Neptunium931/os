.intel_syntax noprefix
.code16

getLowerMemory:
	int 0x12
	ret

getHigherMemory:
	movw ax, 0xe801
	int  0x15
	ret
