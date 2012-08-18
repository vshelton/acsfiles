CC = clang
# Build a 32-bit executable
CFLAGS = -v -m32

t: t.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@
	ls -l $@
	file $@
	./$@
	./$@ 3
	./$@ 10

# Force a rebuild every time
.PHONY: t.c info-t
