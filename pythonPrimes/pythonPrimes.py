#!/usr/bin/env python

import sys
import time

#Basic implementation
def eratosthenes(n):
    multiples = set()
    for i in range(2, n+1):
        if i not in multiples:
            yield i
            multiples.update(range(i*i, n+1, i))

#A different take on the basic implementation thinking about it for a little bit
def eratosthenes2(limit):
    is_prime = [False] * 2 + [True] * (limit - 1)
    for n in xrange(int(limit**0.5 + 1.5)):  #stop at ``sqrt(limit``
        if is_prime[n]:
            for i in xrange(n * n, limit + 1, n):  #start at ``n`` squared
                is_prime[i] = False
    for i in xrange(limit + 1):
        if is_prime[i]: yield i

#Odds only generator, basically a 2 wheel
def iprimes2(limit):
    yield 2
    if limit < 3: return
    lmtbf = (limit - 3) // 2
    #print "lmtbf: " + str(lmtbf)
    buf = [True] * (lmtbf + 1)
    for i in xrange((int(limit ** 0.5) - 3) // 2 + 1):
        #print("outeri " + str(i))
        if buf[i]:
            p = i + i + 3
            s = p * (i + 1) + i
            #print("p: " + str(p) + ", s: " + str(s))
            buf[s::p] = [False] * ((lmtbf - s) // p + 1)
            #print buf
    for i in xrange(lmtbf + 1):
        if buf[i]: yield(i + i + 3)

def primes235(limit):
    yield 2; yield 3; yield 5
    if limit < 7: return
    modPrms = [7,11,13,17,19,23,29,31]
    gaps = [4,2,4,2,4,6,2,6,4,2,4,2,4,6,2,6] # 2 loops for overflow
    ndxs = [0,0,0,0,1,1,2,2,2,2,3,3,4,4,4,4,5,5,5,5,5,5,6,6,7,7,7,7,7,7]
    lmtbf = (limit + 23) // 30 * 8 - 1 # integral number of wheels rounded up
    lmtsqrt = (int(limit ** 0.5) - 7)
    lmtsqrt = lmtsqrt // 30 * 8 + ndxs[lmtsqrt % 30] # round down on the wheel
    buf = [True] * (lmtbf + 1)
    for i in xrange(lmtsqrt + 1):
        if buf[i]:
            ci = i & 7; p = 30 * (i >> 3) + modPrms[ci]
            s = p * p - 7; p8 = p << 3
            for j in xrange(8):
                c = s // 30 * 8 + ndxs[s % 30]
                buf[c::p8] = [False] * ((lmtbf - c) // p8 + 1)
                s += p * gaps[ci]; ci += 1
    for i in xrange(lmtbf - 6 + (ndxs[(limit - 7) % 30])): # adjust for extras
        if buf[i]: yield (30 * (i >> 3) + modPrms[i & 7])

def runSieve(name, limit):
    lprimes = list()
    starttime = time.time()
    if name == "eratosthenes":
        lprimes = list(eratosthenes2(limit))
    if name == "eratosthenes2":
        lprimes = list(eratosthenes2(limit))
    elif name == "iprimes2":
        lprimes = list(iprimes2(limit))
    elif name == "primes235":
        lprimes = list(primes235(limit))
    endtime = time.time()
    elapsed = float(endtime - starttime)

    return(str(len(lprimes)), str(lprimes[-1]), elapsed)

def displayResults(name, count, maxprime, elapsedtime):
    sys.stdout.write(name + "\n")
    sys.stdout.write("\ttime: " + str(elapsedtime*1000) + "ms\n")
    sys.stdout.write("\tPrimes Counted: " + count + "\n")
    sys.stdout.write("\tMax Prime: " + maxprime + "\n")

def main(argv):
    n2 = int(argv[0])
    limit = 1 << n2

    sys.stdout.write("Limit: " + str(limit) + "\n")
    sys.stdout.flush()
    
    (enum, emax, etime) = runSieve("eratosthenes", limit)
    displayResults("Eratosthenes", enum, emax, etime)

    (e2num, e2max, e2time) = runSieve("eratosthenes2", limit)
    displayResults("Eratosthenes2", e2num, e2max, e2time)

    (ip2num, ip2max, ip2time) = runSieve("iprimes2", limit)
    displayResults("iprimes2", ip2num, ip2max, ip2time)

    (pnum, pmax, ptime) = runSieve("primes235", limit)
    displayResults("primes235", pnum, pmax, ptime)

if __name__ == "__main__":
    main(sys.argv[1:])
