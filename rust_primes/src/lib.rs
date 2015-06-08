extern crate num;

use num::iter::range_step;

pub fn eratosthenes(limit: usize) -> (u64, u64) {
    let mut primes = vec![true; limit];
    primes[0] = false;
    primes[1] = false;

    // Use the .. range notation for iterators, and use then directly
    let slimit = f64::sqrt(limit as f64) as usize;
    for i in 2..slimit {
        if primes[i] {
            // Note::still unstable range_step
            for j in num::iter::range_step(i*i, limit, i) {
                primes[j] = false;
            }   
        }   
    }   

    // Practice functional programming techniques
    // 0..limit returns an iterator that can be operated on
    // fold takes the initial pair value (0,7) as variables count, max
    //    as a closure, and then performs the operation until 
    //    the whole iterator sequence is gone through, then
    //    returns the count, max value as the last statement of the
    //    function
    (0..limit).fold((0, 7), |(count, max), prime| {
        if primes[prime] {
            (count + 1, prime as u64)
        } else {
            (count, max)
        }   
    })  
}

pub fn primes2(limit: usize) -> (u64, u64) {
    let lmtbf = (limit - 3) / 2;
    let mut primes = vec![true; lmtbf+1];

    let slimit = f64::sqrt(limit as f64) as usize;
    for i in 0..((slimit - 3) / 2 + 1) {
        if primes[i] {
            let p = i + i + 3;
            let s = p * (i + 1) + i;
            for j in num::iter::range_step(s, lmtbf+1, p) {
                primes[j] = false;
            }   
        }   
    }   

    (0..(lmtbf+1)).fold((1,7), |(count, max), prime| {
        if primes[prime] {
            (count + 1, (prime + prime + 3) as u64)
        } else {
            (count, max)
        }   
    })  
}

pub fn primes235(limit: usize) -> (u64, u64) {
    (0u64,1u64)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn eratosthenes_works() {
        let (pc, max) = eratosthenes(1024);
        assert_eq!(pc, 172);
        assert_eq!(max, 1021);
    }

    #[test]
    fn primes2_works() {
        let (pc, max) = primes2(1024);
        assert_eq!(pc, 172);
        assert_eq!(max, 1021);
    }
}
