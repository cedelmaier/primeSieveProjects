CC = gcc
CPPFLAGS = -g -Wall -Wextra -O3

cPrimes: cPrimes.o
	$(CC) cPrimes.o -o cPrimes

cPrimes.o: cPrimes.c
	$(CC) $(CPPFLAGS) -c cPrimes.c

clean:
	rm -f *.o cPrimes

