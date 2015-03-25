extern crate "rustc-serialize" as rustc_serialize;
extern crate docopt;

use docopt::Docopt;
use std::num::Float;
use std::iter::range_step_inclusive;

// Write the usage string
// As a note, has to match exactly!
static USAGE: &'static str = "
USAGE: rustPrimes <n>
";

#[derive(RustcDecodable, Debug)]
struct Args {
    arg_n: i32,
}

fn main() {
    let args: Args = Docopt::new(USAGE)
                            .and_then(|d| d.decode())
                            .unwrap_or_else(|e| e.exit());

    let limit: u64 = (2f64).powi(args.arg_n) as u64;
    println!("{:?}, limit: {}", args, limit);

    //Call eratosthenes
    eratosthenes(limit);
}

fn eratosthenes(n: u64) {
    println!("Eratosthenes");

    let mut pc = 0u64;
    let mut maxprime = 7u64;

    //set the whole vector to true a priori
    let mut nums = vec![true; n as usize];
    //Set the first set of nums to false for 0,1
    nums[0] = false;
    nums[1] = false;

    let limit: u64 = (n as f64).sqrt() as u64;
    for i in 2..limit {
        for j in range_step_inclusive(i*i, n-1, i) {
            if nums[i as usize] {
                nums[j as usize] = false;
            }
        }
    }

    for x in 2..n {
        if nums[x as usize] {
            pc += 1;
            maxprime = x;
        }
    }

    println!("n = {}, pc = {}, maxprime = {}", n, pc, maxprime);
    //println!("nums: {:?}", nums);
}
