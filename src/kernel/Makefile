kernel_src=./kernelEntry.s

kernel_obj = $(kernel_src:.s=.s.o)

%.s.o: %.s
	$(AS) $(AS_FLAGS) -o $@ $<

kernel.bin: $(kernel_obj)
	$(LD) $(LD_FLAGS) -o $@ $^
