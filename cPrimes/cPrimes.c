/*
Christopher Edelmaier
C implementation of sive of Eratosthenes
Do not use make with optimizations turned on, as there is something in 
iprimes2 that suddely breaks some rules, probably that we're passing
back a structure instead of a tuple.
*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>
#include <time.h>

const unsigned int modPrimes[] = {7, 11, 13, 17, 19, 23, 29, 31};
const unsigned int gaps[] = {4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6};
const unsigned int ndxs[] = {0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7};

typedef struct {
    unsigned int pc;
    unsigned int maxprime;
} primeResults;

primeResults eratosthenes(unsigned int limit);
primeResults iprimes2(unsigned int limit);
primeResults primes235(unsigned int limit);

int main(int argc, char* argv[]) {
    unsigned int limit;
    primeResults eres, ip2, p235;
    double startTime, endTime, timeElapsed;

    limit = 2;

    if(argc > 1) {
        limit = limit << (atoi(argv[1])-1);
    } else {
        limit = limit << (10-1);
    }

    printf("Limit: %d\n", limit);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    eres = eratosthenes(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Eratosthenes: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", eres.pc);
    printf("\tMax prime: %d\n\n\n", eres.maxprime);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    ip2 = iprimes2(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Iprimes2: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", ip2.pc);
    printf("\tMax prime: %d\n\n\n", ip2.maxprime);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    p235 = primes235(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("primes235: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", p235.pc);
    printf("\tMax prime: %d\n\n\n", p235.maxprime);

    return EXIT_SUCCESS;
}

primeResults eratosthenes(unsigned int limit) {
    unsigned int i, j;
    primeResults results;

    results.pc = 0;
    results.maxprime = 7;

    //1 is true
    //C doesn't like large arrays
    //alocate on the heap!
    char* nums = (char*)malloc(limit * sizeof(char));
    memset(nums, 1, limit);

    nums[0] = 0;
    nums[1] = 0;

    for(i = 2; i < sqrt(limit); i++) {
        if(nums[i]) {
            for(j = i*i; j < limit; j += i) {
                nums[j] = 0;
            }
        }
    }
    
    for(i = 0; i < limit; i++) {
        if(nums[i]) {
            results.pc++;
            results.maxprime = i;
        }
    }

    results.pc = results.pc ;
    free(nums);
    return(results);
}

primeResults iprimes2(unsigned int limit) {
    volatile unsigned int pc, maxprime;
    unsigned int lmtbf = (limit - 3) / 2;
    primeResults results;
    results.pc = 0;

    pc = 1;
    maxprime = 0;

    //Declar buffer on the heap!
    char* buf = (char*)malloc((lmtbf+1)*sizeof(char));
    memset(buf,1,lmtbf+1);
    
    for(unsigned int i = 0; i < ((unsigned int)sqrt(limit) - 3) / 2 + 1; i++) {
        //printf("outeri: %ld\n", i);
        if(buf[i]) {
            unsigned int p = i + i + 3;
            unsigned int s = p * (i + 1) + i;
            //printf("p: %ld, s: %ld\n", p, s);
            for(unsigned int j = s; j < (lmtbf + 1); j += p) {
                //printf("Setting %d j to off\n", j);
                buf[j] = 0;
            }
        }
    }

    for(unsigned int i = 0; i < lmtbf+1; i++) {
        if(buf[i]) {
            pc++;
            maxprime = i + i + 3;
        }
    }

    results.pc = pc;
    results.maxprime = maxprime;

    free(buf);
    return(results);
}

primeResults primes235(unsigned int limit) {
    primeResults results;
    results.pc = 0;
    results.maxprime = 0;
    volatile unsigned int pc = 0;
    volatile unsigned int maxprime = 0;
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









