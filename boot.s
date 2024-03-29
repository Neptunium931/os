.intel_syntax noprefix
# Declare constants for the multiboot header.
.equ MBALIGN, 1 << 0            # align loaded modules on page boundaries
.equ MEMINFO, 1 << 1            # provide memory map
.equ MBFLAGS, MBALIGN | MEMINFO # this is the Multiboot 'flag' field
.equ MAGIC, 0x1BADB002          # 'magic number' lets bootloader find the header
.equ CHECKSUM, -(MAGIC + MBFLAGS)   # checksum of above, to prove we are multiboot

# Declare a multiboot header that marks the program as a kernel.
.section .multiboot
.align 4
  .long MAGIC
  .long MBFLAGS
  .long CHECKSUM

# Allocate space for stack
.section .bss
.align 16
stack_bottom:
  .skip 16384 # 16 KiB
stack_top:

# Entry point
.section .text
.globl _start
_start:
  # Set up the stack
  mov esp, stack_top

  # Initialize crucial processor state

  # Call the high-level kernel
  call kernel_main

  # If the system has nothing more to do, put the computer into an infinite loop.
.hang:
  hlt
  jmp .hang
