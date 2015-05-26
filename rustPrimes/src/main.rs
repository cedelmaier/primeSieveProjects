/// Eratosthenes prime sieve program
/// Mostly used as a programming learning experience
extern crate num;

use num::pow;
use num::iter::range;
use num::iter::range_step;

fn main() {
    // The hint hat cmd_args will be a vector of type _ 
    // which is a placeholder for the type, which only 
    // rust knows.  The args() is the normal topography
    // of the location on the machine and what the program
    // was called with.  The map is an iterator adaptor.
    // it returns each x with to_string being called on it
    // and then finally collected into our vector
    let cmd_args: Vec<_> = std::env::args()
        .map(|x| x.to_string())
        .collect();
    println!("Hello, world: {:?}", cmd_args);

    // Cast to our u64 limit
    // Parse the first arg (no checking) into a u64
    // Then use the power to raise 2^num for the limit
    let input_num = cmd_args[1].parse::<u64>();
    let limit:usize = pow(2u64, input_num.unwrap() as usize) as usize;

    println!("Limit: {}", limit);

    // Use destructuring to bind the two variables to eratosthenes
    let (era_pc, era_max) = eratosthenes(limit);
    println!("Eratosthenes");
    println!("\tPrimesCounted: {}", era_pc);
    println!("\tMax prime: {}", era_max);
}

// Basic eratosthenes functin that takes a limit and counts all
// all of the prime numbers below it
fn eratosthenes(limit: usize) -> (u64, u64) {
    let mut pc: u64 = 0;
    let mut maxprime: u64 = 7;

    // Allocate the array and initialize
    let mut primes = vec![true; limit];
    primes[0] = false;
    primes[1] = false;

    let slimit = (limit as f64).sqrt() as usize;
    for i in range(2, slimit) {
        if primes[i] {
            for j in num::iter::range_step(i*i, limit, i) {
                primes[j] = false;
            }
        }
    }

    //let testp: Vec<usize> = primes.iter()
    //                      .enumerate()
    //                      .filter_map(|(pr, &is_pr)| if is_pr { Some(pr) } else {None} )
    //                      .collect();
    //println!("{:?}",testp);

    for p in (0..limit) {
        if primes[p] {
            pc = pc + 1;
            maxprime = p as u64;
        }
    }

    (pc, maxprime)
}
