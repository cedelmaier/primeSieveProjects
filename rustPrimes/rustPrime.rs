use std::iter;

fn int_sqrt(n: uint) -> uint {
    (n as f64).sqrt() as uint
}

fn simple_sieve(limit:uint) -> Vec<uint> {
    if limit < 2 {
        return Vec::new();
    }

    let mut primes: Vec<bool> = Vec::from_elem(limit + 1, true);

    for prime in iter::range_inclusive(2, int_sqrt(limit) + 1) {
        if primes[primes] {
            for multiple in iter::range_step(prime * prime, limit + 1, prime) {
                *primes.get_mut(multiple) = false;
            }
        }
    }

    iter::range_inclusive(2, limit).filter(|&n| primes[n]).collect()
}

fn main() {
    println!("{}", simple_sieve(64))
}
