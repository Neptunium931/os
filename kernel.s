.intel_syntax noprefix

.equ VGA_WIDTH, 80
.equ VGA_HEIGHT, 25

.equ VGA_COLOR_BLACK, 0
.equ VGA_COLOR_BLUE, 1
.equ VGA_COLOR_GREEN, 2
.equ VGA_COLOR_CYAN, 3
.equ VGA_COLOR_RED, 4
.equ VGA_COLOR_MAGENTA, 5
.equ VGA_COLOR_BROWN, 6
.equ VGA_COLOR_LIGHT_GREY, 7
.equ VGA_COLOR_DARK_GREY, 8
.equ VGA_COLOR_LIGHT_BLUE, 9
.equ VGA_COLOR_LIGHT_GREEN, 10
.equ VGA_COLOR_LIGHT_CYAN, 11
.equ VGA_COLOR_LIGHT_RED, 12
.equ VGA_COLOR_LIGHT_MAGENTA, 13
.equ VGA_COLOR_LIGHT_BROWN, 14
.equ VGA_COLOR_WHITE, 15

.global kernel_main
kernel_main:
    mov dh, VGA_COLOR_LIGHT_GREY
    mov dl, VGA_COLOR_BLACK
    call terminal_set_color
    mov esi, hello_string
    call terminal_write_string
    jmp $

# IN = dl: y, dh: x
# OUT = dx: Index with offset 0xB8000 at VGA buffer
# Other registers preserved
terminal_getidx:
    push ax # preserve registers
    shl dh, 1 # multiply by two because every entry is a word that takes up 2 bytes
    mov al, VGA_WIDTH
    mul dl
    mov dl, al
    shl dl, 1 # same
    add dl, dh
    mov dh, 0
    pop ax
    ret

# IN = dl: bg color, dh: fg color
# OUT = none
terminal_set_color:
    shl dl, 4
    or dl, dh
    mov [terminal_color], dl
    ret

# IN = dl: y, dh: x, al: ASCII char
# OUT = none
terminal_putentryat:
    pusha
    call terminal_getidx
    mov ebx, edx
    mov dl, [terminal_color]
    mov byte [0xB8000 + ebx], al
    mov byte [0xB8001 + ebx], dl
    popa
    ret

# IN = al: ASCII char
terminal_putchar:
    mov dx, [terminal_cursor_pos] # This loads terminal_column at DH, and terminal_row at DL
    call terminal_putentryat
    inc dh
    cmp dh, VGA_WIDTH
    jne .cursor_moved
    mov dh, 0
    inc dl
    cmp dl, VGA_HEIGHT
    jne .cursor_moved
    mov dl, 0
.cursor_moved:
    # Store new cursor position
    mov [terminal_cursor_pos], dx
    ret

# IN = cx: length of string, ESI: string location
# OUT = none
terminal_write:
    pusha
.loopy_write:
    mov al, [esi]
    call terminal_putchar
    dec cx
    cmp cx, 0
    je .done_write
    inc esi
    jmp .loopy_write
.done_write:
    popa
    ret

# IN = ESI: zero delimited string location
# OUT = ECX: length of string
terminal_strlen:
    push eax
    push esi
    mov ecx, 0
.loopy_strlen:
    mov al, [esi]
    cmp al, 0
    je .done_strlen
    inc esi
    inc ecx
    jmp .loopy_strlen
.done_strlen:
    pop esi
    pop eax
    ret

# IN = ESI: string location
# OUT = none
terminal_write_string:
    pusha
    call terminal_strlen
    call terminal_write
    popa
    ret

# Exercises:
# - Newline support
# - Terminal scrolling when screen is full
# Note:
# - The string is looped through twice on printing.

.section .data
hello_string:
    .ascii "Hello, kernel World!\n\0"  # \n représente un saut de ligne, \0 représente la fin de la chaîne

.section .bss
terminal_color:
    .byte 0

.section .bss
terminal_cursor_pos:
    terminal_column:
        .byte 0
    terminal_row:
        .byte 0
