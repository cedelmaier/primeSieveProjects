#![feature(test)]

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
    let mod_primes: [usize; 8] = [7,11,13,17,19,23,29,31];
    let gaps: [usize; 16] = [4,2,4,2,4,6,2,6,4,2,4,2,4,6,2,6];
    let ndxs: [usize; 30]  = [0,0,0,0,1,1,2,2,2,2,3,3,4,4,4,4,5,5,5,5,5,5,6,6,7,7,7,7,7,7];

    let lmtbf = (f64::floor((limit as f64) / 30.0) * 8.0 - 1.0) as usize;
    let lmtsqrt_index = f64::sqrt(limit as f64) as usize - 7;
    let lmtsqrt = (f64::floor((lmtsqrt_index as f64) / 30.0) as usize) * 8 + ndxs[lmtsqrt_index %
        30];

    let mut primes = vec![true; lmtbf+1];

    for i in 0..lmtsqrt+1 {
        if primes[i] {
            let mut ci = i & 7;
            let p = 30 * (i >> 3) + mod_primes[ci];
            let mut s = p * p - 7;
            let p8 = p << 3;
            for j in 0..8 {
                let c = (f64::floor((s as f64) / 30.0) as usize) * 8 + ndxs[s % 30];
                for jj in num::iter::range_step(c, lmtbf+1, p8) {
                    primes[jj] = false;
                }
                s = s + p * gaps[ci];
                ci = ci + 1;
            }
        }
    }

    let climit = lmtbf - 6 + ndxs[(limit - 7) % 30];
    (0..climit).fold((3,7), |(count, max), prime| {
        if primes[prime] {
            (count + 1, (30*(prime>>3) + mod_primes[prime&7]) as u64)
        } else {
            (count, max)
        }
    })
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

    #[test]
    fn primes235_works() {
        let (pc, max) = primes235(1024);
        assert_eq!(pc, 172);
        assert_eq!(max, 1021);
    }
}

#[cfg(test)]
mod bench {
    extern crate test;

    #[bench]
    fn basic_sieve_10(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::eratosthenes(usize::pow(2, 10))))
    }

    #[bench]
    fn basic_sieve_25(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::eratosthenes(usize::pow(2, 25))))
    }

    #[bench]
    fn odd_sieve_10(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::primes2(usize::pow(2, 10))))
    }

    #[bench]
    fn odd_sieve_25(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::primes2(usize::pow(2, 25))))
    }

    #[bench]
    fn p235_sieve_10(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::primes235(usize::pow(2, 10))))
    }

    #[bench]
    fn p235_sieve_25(b: &mut test::Bencher) {
        b.iter(|| test::black_box(super::primes235(usize::pow(2, 25))))
    }
}

