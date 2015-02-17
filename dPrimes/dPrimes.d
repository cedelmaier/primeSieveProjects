import std.stdio;
import std.getopt;
import std.typecons;
import std.math;
import std.datetime;

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

double timeIt(int function(int) func, int arg) {
    StopWatch sw;
    sw.start();
    func(arg);
    sw.stop();
    //Returns in seconds here
    return sw.peek().usecs / 1_000_000.0;
}




