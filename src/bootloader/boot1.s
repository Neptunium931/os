.intel_syntax noprefix
.code16

.org 0x1000
.text

movb al, 'S'
movb ah, 0x0e
int  0x10
