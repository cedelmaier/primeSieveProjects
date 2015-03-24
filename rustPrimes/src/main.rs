extern crate "rustc-serialize" as rustc_serialize;
extern crate docopt;

use docopt::Docopt;
use std::num::Float;

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
}
