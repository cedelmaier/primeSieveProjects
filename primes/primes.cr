MODPRIMES = [7,11,13,17,19,23,29,31]
GAPS = [4,2,4,2,4,6,2,6,4,2,4,2,4,6,2,6]
NDXS = [0,0,0,0,1,1,2,2,2,2,3,3,4,4,4,4,5,5,5,5,5,5,6,6,7,7,7,7,7,7]

def primes235(limit)
  lmtbf = ((limit / 30).floor * 8 - 1).to_i
  lmtsqrt_index = (Math.sqrt(limit) - 7).to_i
  lmtsqrt = ((lmtsqrt_index/30).floor * 8 + NDXS[lmtsqrt_index % 30]).to_i

  primes = Array(Bool).new(lmtbf+1, true)

  (0..lmtsqrt+1).each do |i|
    if primes[i]
      ci = i & 7
      p = 30 * (i >> 3) + MODPRIMES[ci]
      s = p * p - 7
      p8 = p << 3
      (0..8).each do |_|
        c = (s / 30).floor * 8 + NDXS[s % 30]
        jj = c
        while jj <= lmtbf+1
          primes[jj] = false
          jj += p8
        end
        s = s + p * GAPS[ci]
        ci += 1
      end
    end
  end

  climit = lmtbf - 6 + NDXS[(limit.to_i - 7) % 30]
  count = 3
  max = 7
  (0..climit-1).each do |prime|
    if primes[prime]
      count += 1
      max = 30*(prime>>3) + MODPRIMES[prime&7]
    end
  end

  {count, max}
end

n = (ARGV[0]? || 10).to_i
limit = 2**n
puts "limit: #{limit}\n"
res = primes235(limit)
puts "nprimes: #{res[0]}, max prime: #{res[1]}\n"
