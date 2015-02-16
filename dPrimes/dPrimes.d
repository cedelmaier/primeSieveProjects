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
    auto elapsed = sw.peek().usecs / 1_000.0;
    printf("Eratosthenes: %.4fms\n", elapsed);
    printf("\tPrimes counted: %ld\n", e[0]);
    printf("\tMax prime: %ld\n\n\n", e[1]);
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

double timeIt(int function(int) func, int arg) {
    StopWatch sw;
    sw.start();
    func(arg);
    sw.stop();
    //Returns in seconds here
    return sw.peek().usecs / 1_000_000.0;
}




