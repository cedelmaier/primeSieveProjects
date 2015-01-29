CC = gcc
CPPFLAGS = -g -Wall -Wextra

release: CPPFLAGS += -O3
release: cPrimes

cPrimes: cPrimes.o
	$(CC) cPrimes.o -o cPrimes

cPrimes.o: cPrimes.c
	$(CC) $(CPPFLAGS) -c cPrimes.c

clean:
	rm -f *.o cPrimes

