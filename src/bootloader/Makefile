boot0_src=./boot0.s
boot1_src=./boot1.s

boot0_obj = $(boot0_src:.s=.s.o)
boot1_obj = $(boot1_src:.s=.s.o)

%.s.o: %.s
	$(AS) $(AS_FLAGS) -o $@ $<

boot0.bin: $(boot0_obj)
	$(LD) $(LD_FLAGS) -Ttext 0x7c00 --oformat binary -o $@ $^

boot1.bin: $(boot1_obj)
	$(LD) $(LD_FLAGS) -Ttext 0x1000 --oformat binary -o $@ $^
