echo C
../xtime.rb ./primes_c 30
echo D
../xtime.rb ./primes_d -n 30
#something is screwed up in gdc math
#echo D GDC
#../xtime.rb ./primes_d_gdc -n 30
echo D LDC
../xtime.rb ./primes_d_ldc -n 30
echo Go
../xtime.rb ./primes_go -n 30
echo Java
../xtime.rb java javaPrimes 30
echo Nim Clang
../xtime.rb ./primes_nim_clang 30
echo Nim Gcc
../xtime.rb ./primes_nim_gcc 30
echo Rust
../xtime.rb ./primes_rs 30
