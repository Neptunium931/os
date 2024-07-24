.intel_syntax noprefix
.code16

.text

movb al, 'S'
movb ah, 0x0e
int  0x10
