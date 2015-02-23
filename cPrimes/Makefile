CC = gcc
CPPFLAGS = -g -Wall -Wextra -std=c11 -O3

cPrimes: cPrimes.o
	$(CC) cPrimes.o -o cPrimes -lm

cPrimes.o: cPrimes.c
	$(CC) $(CPPFLAGS) -c cPrimes.c

clean:
	rm -f *.o cPrimes

