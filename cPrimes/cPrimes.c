#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

typedef struct {
    long pc;
    long maxprime;
} primeResults;

primeResults eratosthenes(long limit);

int main(int argc, char* argv[]) {
    long limit, pc, maxprime;
    primeResults eres;
    double startTime, endTime, timeElapsed;

    limit = 2;

    if(argc > 1) {
        limit = limit << (atoi(argv[1])-1);
    } else {
        limit = limit << (10-1);
    }
     
    pc = 4;
    maxprime = 7;

    printf("Limit: %ld\n", limit);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    eres = eratosthenes(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Eratosthenes: %.4fs\n", timeElapsed);
    printf("\tPrimes counted: %ld\n", eres.pc);
    printf("\tMax prime: %ld\n\n\n", eres.maxprime);

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
    long* nums = (long*)malloc(limit * sizeof(long));
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

//primeResults iprimes2(long limit) {
//    long lmtbf = (limit - 3) / 2;
//
//    
//}
