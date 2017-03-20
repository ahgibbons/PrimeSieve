extern crate bit_vec;

use std::env;
use std::fs::File;
use std::io::{Write, BufWriter};
use bit_vec::BitVec;


fn prime_sieve<W>(limit: usize, mut output: W) -> u32 
    where W: Write
{
    let mut prime_mask = BitVec::from_elem(limit, true);
    prime_mask.set(0, false);
    prime_mask.set(1, false);
    
    let mut prime_count = 0;
    const FIRST_PRIME: usize = 2;

    // Main sieve loop
    for p in FIRST_PRIME..limit {
        if prime_mask[p] {
            writeln!(output, "{}", p).expect("Unable to write to file");
            prime_count += 1;
            let mut i = 2 * p;
            while i < limit {
                prime_mask.set(i,false);
                i += p;
            }
        }
    }
    prime_count
}


fn main() {
    let args: Vec<_> = env::args().collect();
    let limit: usize = args[1]
        .trim()
        .parse()
        .expect("Wanted a number");
    
    let ofile = &args[2];
    let f = File::create(ofile).expect("Unable to create file");
    let f = BufWriter::new(f);

    let np = prime_sieve(limit, f);
    println!("Found {} primes less than {}. Wrote to {}", 
             np, limit, ofile);
}
