#!/usr/bin/env ruby

require 'optparse'
require 'benchmark'
require_relative 'eratosthenes'

#command line requires that a flag be passed
#otherwise the default of 2^10 for the limit
#will be used
#
#Usage: ./rubyPrimes.rb -n 24

options = {:limit => 4}
parser = OptionParser.new do |opts|
    opts.banner = "Usage: rubyPrimes.rb [limit]"

    opts.on('-n n', '--nlimit=n', OptionParser::DecimalInteger, 'Limit') do |limit|
        options[:limit] = limit
    end
end
parser.parse!

slimit = 2 << (options[:limit] - 1)

$stdout.sync = true

printf("Limit: %d\n", slimit)
pc = []
maxprime = []

Benchmark.bmbm {|x|
    x.report("eratosthenes") { 
        pnums = eratosthenes(slimit)

        pc.push(pnums.length)
        maxprime.push(pnums[-1])
    }
    x.report("eratosthenes2") { 
        pnums = eratosthenes2(slimit)
        
        pc.push(pnums.length)
        maxprime.push(pnums[-1])
    }
#    x.report("eratosthenes built in") {
#        pnums = eratosthenesBuiltin(slimit)
#
#        pc.push(pnums.length)
#        maxprime.push(pnums[-1])
#    }
}

pc.each{|p| printf("Primes Counted: %d\n", p)}
maxprime.each{|m| printf("Max Prime: %d\n", m)}

