CC = clang
CFLAGS = -v

t: t.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@
	(echo; ls -l $@; echo)

.PHONY: t.c
