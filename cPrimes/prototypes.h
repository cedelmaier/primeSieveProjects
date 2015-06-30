/*
 * Christopher Edelmaier
 * C implementation of sive of Eratosthenes
 * Have to use volatile ints for the return values,
 * otherwise they get optimized away!
 * */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>
#include <time.h>

typedef struct {
    unsigned int pc;
    unsigned int maxprime;
} primeResults;

primeResults eratosthenes(unsigned int limit);
primeResults iprimes2(unsigned int limit);
primeResults primes235(unsigned int limit);

