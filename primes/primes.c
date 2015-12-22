/*
Christopher Edelmaier
C implementation of sive of Eratosthenes
Have to use volatile ints for the return values,
otherwise they get optimized away!
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>

typedef struct {
    unsigned int pc;
    unsigned int maxprime;
} primeResults;

primeResults primes235(unsigned int limit);

const unsigned int modPrimes[] = {7, 11, 13, 17, 19, 23, 29, 31};
const unsigned int gaps[] = {4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6};
const unsigned int ndxs[] = {0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7};

int main(int argc, char* argv[]) {
    unsigned int limit = 10;
    primeResults eres, ip2, p235;
    double startTime, endTime, timeElapsed;

    if(argc > 1) {
        limit = (atoi(argv[1]));
    }

    limit = 1 << limit;
    printf("limit: %d\n", limit);

    p235 = primes235(limit);

    printf("nprimes: %d, max prime: %d\n", p235.pc, p235.maxprime);

    return EXIT_SUCCESS;
}

primeResults primes235(unsigned int limit) {
    primeResults results;
    volatile unsigned int pc;
    volatile unsigned int maxprime;
    unsigned int lmtbf = floor((limit + 23 ) / 30) * 8 - 1;
    unsigned int lmtsqrt = (unsigned int)(sqrt(limit) - 7);
    //This needs to be signed!
    long lmtmod = lmtsqrt % 30;
    unsigned int fIndex = 0;
    if(lmtmod < 0){
        fIndex = 30 + lmtmod;
    } else {
        fIndex = lmtmod;
    }
    lmtsqrt = floor(lmtsqrt/30)*8 + ndxs[fIndex];
    char* buf = (char*)malloc((lmtbf+1)*sizeof(char));
    memset(buf,1,lmtbf+1);

    //Algorithm
    for(unsigned int i = 0; i < lmtsqrt+1; i++) {
        if(buf[i]) {
            unsigned int ci = i & 7;
            unsigned int p = 30*(i>>3) + modPrimes[ci];
            unsigned int s = p * p - 7;
            unsigned int p8 = p << 3;
            for(unsigned int j = 0; j < 8; j++) {
                unsigned int c = floor(s/30)*8 + ndxs[s%30];
                for(unsigned int jj = c; jj < lmtbf+1; jj += p8) {
                    buf[jj] = 0;
                }
                s += p * gaps[ci];
                ci+=1;
            }
        }
    }

    pc = 3;
    maxprime = 7;

    for(unsigned int i = 0; i < lmtbf-6+(ndxs[(limit-7)%30]); i++) {
        if(buf[i]) {
            pc++;
            maxprime = 30*(i>>3) + modPrimes[i&7];
        }
    }

    results.pc = pc;
    results.maxprime = maxprime;

    free(buf);
    return(results);
}

