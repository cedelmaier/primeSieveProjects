import
  parseopt2, strutils, math, times,
  algorithm

proc eratosthenes(limit: int): (uint64, uint64) =
  var pc: uint64 = 0
  var maxprime: uint64 = 7

  # Declaring a false array is easy, like in D
  var primes = newSeq[bool](limit)
  # The old way of doing things, devel gives us
  # a fill func for arrays
  # for x in primes.mitems: x = true
  fill(primes, primes.low, primes.high, true)
  primes[0] = false
  primes[1] = false

  for i in 2..(int)sqrt((float)limit):
    if primes[i]:
      for j in countup(i*i, limit-1, i):
        primes[j] = false

  for i in 0..primes.len() - 1:
    if primes[i]:
      inc(pc)
      maxprime = (uint64)i

  (pc, maxprime)

proc iprimes2(limit: int): (uint64, uint64) =
  var pc: uint64 = 1
  var maxprime: uint64 = 0

  let lmtbf = (int)((limit - 3) / 2)
  var primes = newSeq[bool](lmtbf+1)
  fill(primes, primes.low, primes.high, true)

  for i in 0..(int)(((int)sqrt((float)limit) - 3) / 2 + 1):
    if primes[i]:
      let p = i + i + 3
      let s = p * (i + 1) + i
      for j in countup(s, lmtbf, p):
        primes[j] = false

  for i in 0..primes.len() - 1:
    if primes[i]:
      inc(pc)
      maxprime = (uint64)(i + i + 3)

  (pc, maxprime)

proc primes235(limit: int): (uint64, uint64) =
  const
    modPrimes = [7, 11, 13, 17, 19, 23, 29, 31]
    gaps = [4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6]
    ndxs = [0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7]
  var pc: uint64 = 3
  var maxprime: uint64 = 7

  let lmtbf = (int)((limit + 23 ) / 30) * 8 - 1
  let lmtsqrt1 = (int)sqrt((float)limit) - 7
  let fIndex = lmtsqrt1 %% 30
  let lmtsqrt = (int)(lmtsqrt1/30)*8 + ndxs[fIndex]
  var primes = newSeq[bool](lmtbf+1)
  fill(primes, primes.low, primes.high, true)
  # echo("lmtbf: ", lmtbf, ", fIndex: ", fIndex, ", lmtsqrt: ", lmtsqrt)

  for i in 0..lmtsqrt:
    if primes[i]:
      var ci: int = i and 7
      let p: int = 30*(i shr 3) + modPrimes[ci]
      var s: int = p * p - 7
      let p8: int = p shl 3
      # echo("i: ", i, ", ci: ", ci, ", p: ", p, ", s: ", s, ", p8: ", p8)
      for j in 0..7:
        let c: int = (int)(s/30)*8 + ndxs[s%%30]
        # echo("\tj: ", j, ", c: ", c)
        for jj in countup(c, lmtbf, p8):
          primes[jj] = false
        s += p * gaps[ci]
        inc(ci)

  for i in 0..lmtbf-6+(ndxs[(limit-7)%%30])-1:
    if primes[i]:
      inc(pc)
      maxprime = (uint64)(30*(i shr 3) + modPrimes[i and 7])

  (pc, maxprime)

proc main() =
  # parse arguments
  var inLimit = 10
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      inLimit = parseInt(key)
    else: discard

  # compute the limit
  let limit = 1 shl inLimit
  echo("Limit: ", limit)

  var t0 = cpuTime()
  let (eraPc, eraMax) = eratosthenes(limit)
  var t1 = cpuTime() - t0
  echo("Eratosthenes: ", t1*1000, "ms")
  echo("\tPrimes Counted: ", eraPc)
  echo("\tMax Prime: ", eraMax)

  t0 = cpuTime()
  let (ip2Pc, ip2Max) = iprimes2(limit)
  t1 = cpuTime() - t0
  echo("iprimes2: ", t1*1000, "ms")
  echo("\tPrimes Counted: ", ip2Pc)
  echo("\tMax Prime: ", ip2Max)

  t0 = cpuTime()
  let (p235Pc, p235Max) = primes235(limit)
  t1 = cpuTime() - t0
  echo("primes235: ", t1*1000, "ms")
  echo("\tPrimes Counted: ", p235Pc)
  echo("\tMax Prime: ", p235Max)

when isMainModule:
  main()
