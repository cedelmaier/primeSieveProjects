/// Eratosthenes prime sieve program
extern crate num;

fn main() {
    // Read the input number directly, but need the limit binding
    // occur so that the compiler can infer the type
    let input_num = 
        std::env::args()
        .nth(1)
        .and_then(|x| x.parse().ok())
        .unwrap();
    
    let limit = usize::pow(2, input_num);
    println!("limit: {}", limit);

    let (p235_pc, p235_max) = primes235(limit);

    println!("nprimes: {}, maxprime: {}", p235_pc, p235_max);
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
            for _ in 0..8 {
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

