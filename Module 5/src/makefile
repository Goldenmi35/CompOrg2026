CC	:= gcc
CFLAGS	:= -g
LDFLAGS	:= -g

PROGS	:= celsiusToF fahrenheitToC negateInput feetToInches totalInchesConverter multByTen swap

all:	$(PROGS)

%.o:	%.s
	$(CC) $(CFLAGS) -c $< -o $@

%:	%.o
	$(CC) $(LDFLAGS) $< -o $@

clean:
	rm -f $(PROGS) *.o
