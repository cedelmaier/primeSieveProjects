/// Eratosthenes prime sieve program
extern crate rust_primes;
extern crate time;

use rust_primes::eratosthenes;
use rust_primes::primes2;
use rust_primes::primes235;

fn main() {
    // Read the input number directly, but need the limit binding
    // occur so that the compiler can infer the type
    let input_num = 
        std::env::args()
        .nth(1)
        .and_then(|x| x.parse().ok())
        .unwrap();
    
    let limit = usize::pow(2, input_num);
    println!("Limit: {}", limit);

    let mut start = time::precise_time_ns();
    let (era_pc, era_max) = eratosthenes(limit);
    let mut end = time::precise_time_ns();

    println!("Eratosthenes: {}ms", (end - start)/1_000_000);
    println!("\tPrimes Counted: {}", era_pc);
    println!("\tMaxPrime: {}", era_max);

    start = time::precise_time_ns();
    let (p2_pc, p2_max) = primes2(limit);
    end = time::precise_time_ns();

    println!("Primes2(odd): {}ms", (end - start)/1_000_000);
    println!("\tPrimes Counted: {}", p2_pc);
    println!("\tMaxPrime: {}", p2_max);

    start = time::precise_time_ns();
    let (p235_pc, p235_max) = primes235(limit);
    end = time::precise_time_ns();

    println!("Primes235 {}ms", (end - start)/1_000_000);
    println!("\tPrimes Counted: {}", p235_pc);
    println!("\tMaxPrime: {}", p235_max);
}

