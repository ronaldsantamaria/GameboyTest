ASM = rgbasm
LINK = rgblink
FIX = rgbfix

BINS = game.gb
OBJS = main.o

all: $(BINS)

main.o: main.asm
	$(ASM) -o $@ $<

game.gb: $(OBJS)
	$(LINK) -o game.gb $(OBJS)
	$(FIX) -v -p 0 game.gb

clean:
	rm -f *.o *.gb

.PHONY: clean all