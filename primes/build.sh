gcc -std=c11 -O3 -o primes_c primes.c -lm
go build -o primes_go primes.go
dmd -ofprimes_d -O -release -inline primes.d
gdc -o primes_d_gdc -O3 -frelease -finline primes.d
ldc2 -ofprimes_d_ldc -O5 -release -inline primes.d
nim c -o:primes_nim_clang -d:release --cc:clang --verbosity:0 primes.nim
nim c -o:primes_nim_gcc -d:release --cc:gcc --verbosity:0 primes.nim
