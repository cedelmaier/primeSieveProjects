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
#include <time.h>

typedef struct {
    long pc;
    long maxprime;
} primeResults;

primeResults eratosthenes(long limit);
primeResults iprimes2(long limit);

int main(int argc, char* argv[]) {
    long limit;
    primeResults eres, ip2;
    double startTime, endTime, timeElapsed;

    limit = 2;

    if(argc > 1) {
        limit = limit << (atoi(argv[1])-1);
    } else {
        limit = limit << (10-1);
    }

    printf("Limit: %ld\n", limit);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    eres = eratosthenes(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Eratosthenes: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %ld\n", eres.pc);
    printf("\tMax prime: %ld\n\n\n", eres.maxprime);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    ip2 = iprimes2(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Iprimes2: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %ld\n", ip2.pc);
    printf("\tMax prime: %ld\n\n\n", ip2.maxprime);

    return EXIT_SUCCESS;
}

primeResults eratosthenes(long limit) {
    long i, j;
    primeResults results;

    results.pc = 4;
    results.maxprime = 7;

    //1 is true
    //C doesn't like large arrays
    //alocate on the heap!
    char* nums = (char*)malloc(limit * sizeof(char));
    for(i = 0; i < limit; i++) {
        nums[i] = 1;
    }

    for(i = 2; i < sqrt(limit); i++) {
        for(j = i*i; j < limit; j += i) {
            if(nums[i]) {
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

    results.pc = results.pc - 4 - 2;
    free(nums);
    return(results);
}

primeResults iprimes2(long limit) {
    long i, j;
    long lmtbf = (limit - 3) / 2;
    primeResults results;
    results.pc++;

    //Declar buffer on the heap!
    char* buf = (char*)malloc((lmtbf+1)*sizeof(char));

    for(i = 0; i < lmtbf+1; i++) {
        buf[i] = 1;
    }
    
    for(i = 0; i < ((long)sqrt(limit) - 3) / 2 + 1; i++) {
        //printf("outeri: %ld\n", i);
        if(buf[i]) {
            long p = i + i + 3;
            long s = p * (i + 1) + i;
            //printf("p: %ld, s: %ld\n", p, s);
            for(j = s; j < (lmtbf + 1); j += p) {
                //printf("Setting %d j to off\n", j);
                buf[j] = 0;
            }
        }
    }

    for(i = 0; i < lmtbf+1; i++) {
        if(buf[i]) {
            results.pc++;
            results.maxprime = i + i + 3;
        }
    }

    free(buf);
    return(results);
}











