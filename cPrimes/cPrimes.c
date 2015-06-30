/*
Christopher Edelmaier
C implementation of sive of Eratosthenes
Have to use volatile ints for the return values,
otherwise they get optimized away!
*/

#include "prototypes.h"

int main(int argc, char* argv[]) {
    unsigned int limit = 10;
    primeResults eres, ip2, p235;
    double startTime, endTime, timeElapsed;

    if(argc > 1) {
        limit = (atoi(argv[1]));
    }

    limit = 1 << limit;
    printf("Limit: %d\n", limit);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    eres = eratosthenes(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Eratosthenes: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", eres.pc);
    printf("\tMax prime: %d\n", eres.maxprime);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    ip2 = iprimes2(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("Iprimes2: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", ip2.pc);
    printf("\tMax prime: %d\n", ip2.maxprime);

    startTime = (float)clock()/CLOCKS_PER_SEC;
    p235 = primes235(limit);
    endTime = (float)clock()/CLOCKS_PER_SEC;
    timeElapsed = endTime - startTime;

    printf("primes235: %.4fms\n", 1000*timeElapsed);
    printf("\tPrimes counted: %d\n", p235.pc);
    printf("\tMax prime: %d\n", p235.maxprime);

    return EXIT_SUCCESS;
}

