.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start

.section .data

gdt_start:
gdt_null:
	.long 0x00000000
	.long 0x00000000

gdt_code:
	.word 0xFFFF
	.word 0x0000
	.byte 0x00
	.byte 0b10011010 # pres, priv, type, Type Flags
	.byte 0b11001111 # Other Flags, Limit
	.byte 0x00

gdt_data:
	.word 0xFFFF
	.word 0x0000
	.byte 0x00
	.byte 0b10010010 # pres, priv, type, Type Flags
	.byte 0b11001111 # Other Flags, Limit
	.byte 0x00

gdt_end:
gdt_descriptor:
	.word gdt_end - gdt_start- 1
	.long gdt_start
