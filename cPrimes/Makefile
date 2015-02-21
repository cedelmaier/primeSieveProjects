CC = gcc-4.9
CPPFLAGS = -g -Wall -Wextra -std=c11 -O3

cPrimes: cPrimes.o
	$(CC) cPrimes.o -o cPrimes

cPrimes.o: cPrimes.c
	$(CC) $(CPPFLAGS) -c cPrimes.c

clean:
	rm -f *.o cPrimes

