import std.stdio;
import std.getopt;
import std.typecons;
import std.math;
import std.datetime;

immutable(uint)[] modPrimes = [7, 11, 13, 17, 19, 23, 29, 31];
immutable(uint)[] gaps = [4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6];
immutable(uint)[] ndxs = [0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7];

void main(string[] args) {
    uint limit = 10;
    StopWatch sw;
    getopt(args, "n", &limit);
    limit = 1 << limit;
    writeln("Limit: ", limit);

    sw.start();
    auto e = eratosthenes(limit);
    sw.stop();
    auto elapsedE = sw.peek().usecs / 1_000.0;
    printf("Eratosthenes: %.4fms\n", elapsedE);
    printf("\tPrimes counted: %ld\n", e[0]);
    printf("\tMax prime: %ld\n\n\n", e[1]);

    sw.reset();
    sw.start();
    auto ip2 = iprimes2(limit);
    sw.stop();
    auto elapsedIp2 = sw.peek().usecs / 1_000.0;
    printf("Iprimes2: %.4fms\n", elapsedIp2);
    printf("\tPrimes counted: %ld\n", ip2[0]);
    printf("\tMax prime: %ld\n\n\n", ip2[1]);

    sw.reset();
    sw.start();
    auto p235 = primes235(limit);
    sw.stop();
    auto elapsedp235 = sw.peek().usecs / 1_000.0;
    printf("primes235: %.4fms\n", elapsedp235);
    printf("\tPrimes counted: %ld\n", p235[0]);
    printf("\tMax prime: %ld\n\n\n", p235[1]);
}

//Typecons gets us tuple operations, neat huh
Tuple!(uint, uint) eratosthenes(uint limit) {
    //First, construct our array
    bool[] nums = new bool[limit];
    nums[] = true;

    for(uint i = 2; i < sqrt(cast(float)limit); i++) {
        for(uint j = i*i; j < limit; j += i) {
            if(nums[i]) {
                nums[j] = false;
            }
        }
    }

    uint pc = 0, maxprime = 0;
    for(uint i = 0; i < limit; i++) {
        if(nums[i]) {
            pc++;
            maxprime = i;
        }
    }

    pc -= 2;

    return tuple(pc, maxprime);
}

Tuple!(uint, uint) iprimes2(uint limit) {
    uint lmtbf = (limit - 3) / 2;
    bool[] buf = new bool[lmtbf+1];
    buf[] = true;

    for(uint i = 0; i < (sqrt(cast(float)limit) - 3) / 2 + 1; i++) {
        if(buf[i]) {
            uint p = i + i + 3;
            uint s = p * (i + 1) + i;
            for(uint j = s; j < (lmtbf + 1); j += p) {
                buf[j] = false;
            }
        }
    }

    uint pc = 1, maxprime = 0;
    for(uint i = 0; i < (lmtbf + 1); i++) {
        if(buf[i]) {
            pc++;
            maxprime = i + i + 3;
        }
    }

    return tuple(pc, maxprime);
}

Tuple!(uint, uint) primes235(uint limit) {
    uint lmtbf = (limit + 23 ) / 30 * 8 - 1;
    long lmtsqrt_l = cast(long)(sqrt(cast(float)limit) - 7);
    long lmtmod = lmtsqrt_l % 30;
    long fIndex = 0;
    if(lmtmod < 0){
        fIndex = 30 + lmtmod;
    } else {
        fIndex = lmtmod;
    }
    uint lmtsqrt = cast(uint)(lmtsqrt_l/30*8 + ndxs[fIndex]);

    bool[] buf = new bool[lmtbf+1];
    buf[] = true;

    //Algorithm
    for(uint i = 0; i < lmtsqrt+1; i++) {
        if(buf[i]) {
            uint ci = i & 7;
            uint p = 30*(i>>3) + modPrimes[ci];
            uint s = p * p - 7;
            uint p8 = p << 3;
            for(uint j = 0; j < 8; j++) {
                uint c = s/30*8 + ndxs[s%30];
                for(uint jj = c; jj < lmtbf+1; jj += p8) {
                    buf[jj] = false;
                }
                s += p * gaps[ci];
                ci+=1;
            }
        }
    }

    uint pc = 3, maxprime = 7;

    for(uint i = 0; i < lmtbf-6+(ndxs[(limit-7)%30]); i++) {
        if(buf[i]) {
            pc++;
            maxprime = 30*(i>>3) + modPrimes[i&7];
        }
    }

    return tuple(pc, maxprime);
}




