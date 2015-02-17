#First sieve of eratosthenes, based on original 
# sieve method
def eratosthenes(n)
    nums = [nil, nil, *2..n]
    (2..Math.sqrt(n)).each do |i|
        (i**2..n).step(i) {|m| nums[m] = nil} if nums[i]
    end
    nums.compact
end

#Second method taken from rosettacode.com
#Based on a 23 wheel,
#Skips every even number, and every number
#Divisible by 3
def eratosthenes2(n)
    #For odd i, if i is prime, nums[i >> 1] is true
    #Set false for all multiples of 3.
    nums = [true, false, true] * ((n + 5) / 6)
    nums[0] = false     #1 is not prime.
    nums[1] = true      #3 is prime.

    puts n
    puts nums.inspect

    #Outer loop and both inner loops are skipping multiples of 2 and 3.
    #Outer loop checks i * i > n, same as i > Math.sqrt(n)
    i = 5
    until (m = i * i) > n
        print "i: " + i.to_s + ", m: " + m.to_s + "\n"
        if nums[i >> 1]
            i_times_2 = i << 1
            i_times_4 = i << 2
            while m <= n
                nums[m >> 1] = false
                m += i_times_2
                nums[m >> 1] = false
                m += i_times_4  #When i = 5, skip 45, 75, 105, ...
            end
        end
        i += 2
        if nums[i >> 1]
            m = i * i
            i_times_2 = i << 1
            i_times_4 = i << 2
            while m <= n
                nums[m >> 1] = false
                m += i_times_4  #When i = 7, skip 63, 105, 147
                nums[m >> 1] = false
                m += i_times_2
            end
        end
        i += 4
    end

    puts nums.inspect

    primes = [2]
    nums.each_index {|i| primes << (i * 2 + 1) if nums[i]}
    primes.pop while primes.last > n
    primes
end

#Ruby also provides a built in version, much slower unless it's already
#Been initialized
def eratosthenesBuiltin(n)
    require 'prime'
    primes = Prime::EratosthenesGenerator.new.take_while {|i| i <= n}
    primes
end

