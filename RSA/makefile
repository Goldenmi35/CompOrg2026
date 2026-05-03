All: jpatto23_team8_RSA
LIB=jpatto23_team8_RSALib.o
CC=gcc

jpatto23_team8_RSA: jpatto23_team8_RSA.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
