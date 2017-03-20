use std::env;
use std::fs::File;
use std::io::{Write, BufWriter};



fn prime_sieve(n: usize, ofile: &String) -> u32 {
    let f = File::create(ofile).expect("Unable to create file");
    let mut f = BufWriter::new(f);

    let mut prime_mask: Vec<bool> = vec![true;n];
    prime_mask[0] = false;
    prime_mask[1] = false;
    let mut p = 2;  // First prime number
    
    let mut count = 0;  // Total number of primes found
    let mut i;

    // Main sieve loop
    while p<n {
        if prime_mask[p] {
            f.write_all(format!("{}\n",p).as_bytes())
                .expect("Unable to write to file");
            count+=1;
            i=2*p;
            while i<n {
                prime_mask[i] = false;
                i += p;
            }
        }
        p+=1;
    }
    count
}


fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = args[1]
        .trim()
        .parse()
        .expect("Wanted a number");
    let ofile = &args[2];
    let np = prime_sieve(n,ofile);
    println!("Found {} primes less than {}. Wrote to {}", np, n, &args[2]);
}
