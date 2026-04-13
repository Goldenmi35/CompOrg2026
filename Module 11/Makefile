# Compiler
CC = gcc

# Flags (adjust if needed for ARM toolchain)
CFLAGS = -g

# Targets
TARGETS = mult fib fact

all: $(TARGETS)

# ---------------------------------
# Build rules
# ---------------------------------

mult: mult.s
	$(CC) $(CFLAGS) -o mult mult.s

fib: fib.s
	$(CC) $(CFLAGS) -o fib fib.s

fact: fact.s
	$(CC) $(CFLAGS) -o fact fact.s

# ---------------------------------
# Clean
# ---------------------------------
clean:
	rm -f $(TARGETS)
