/// Eratosthenes prime sieve program
extern crate rust_primes;

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

    let (era_pc, era_max) = eratosthenes(limit);

    println!("Eratosthenes");
    println!("\tPrimes Counted: {}", era_pc);
    println!("\tMaxPrime: {}", era_max);

    let (p2_pc, p2_max) = primes2(limit);

    println!("Primes2(odd)");
    println!("\tPrimes Counted: {}", p2_pc);
    println!("\tMaxPrime: {}", p2_max);

    let (p235_pc, p235_max) = primes235(limit);
}

