import std.stdio;
import std.getopt;
import std.typecons;
import std.math;

immutable(uint)[] modPrimes = [7, 11, 13, 17, 19, 23, 29, 31];
immutable(uint)[] gaps = [4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6];
immutable(uint)[] ndxs = [0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7];

void main(string[] args) {
    uint limit = 10;
    getopt(args, "n", &limit);
    limit = 1 << limit;
    writeln("limit: ", limit);

    auto p235 = primes235(limit);
    printf("nprimes: %ld, max prime: %ld\n", p235[0], p235[1]);
}

Tuple!(uint, uint) primes235(uint limit) {
    uint lmtbf = (limit + 23 ) / 30 * 8 - 1;
    long lmtsqrt_l = cast(long)(sqrt(cast(float)limit) - 7);
    uint lmtsqrt = cast(uint)(lmtsqrt_l/30*8 + ndxs[lmtsqrt_l % 30]);
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

