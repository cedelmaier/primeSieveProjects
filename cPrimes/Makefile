CC = gcc
CPPFLAGS = -g -Wall -Wextra -std=c11 -O3

cPrimes: cPrimes.o eratosthenes.o
	$(CC) cPrimes.o eratosthenes.o -o cPrimes -lm

cPrimes.o: cPrimes.c prototypes.h
	$(CC) $(CPPFLAGS) -c cPrimes.c

eratosthenes.o: eratosthenes.c prototypes.h
	$(CC) $(CPPFLAGS) -c eratosthenes.c

clean:
	rm -f *.o cPrimes

