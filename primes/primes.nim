import
  parseopt2, strutils, math,
  algorithm

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

  for i in 0..lmtsqrt:
    if primes[i]:
      var ci: int = i and 7
      let p: int = 30*(i shr 3) + modPrimes[ci]
      var s: int = p * p - 7
      let p8: int = p shl 3
      for j in 0..7:
        let c: int = (int)(s/30)*8 + ndxs[s%%30]
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
  echo("limit: ", limit)

  let (p235Pc, p235Max) = primes235(limit)
  echo("nprimes: ", p235Pc, ", max prime: ", p235Max)

when isMainModule:
  main()
