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

when isMainModule:
  main()
