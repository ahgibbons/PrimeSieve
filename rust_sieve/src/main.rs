use std::env;
use std::io;

fn main() {
    println!("Hello, world!");
    let args: Vec<String> = env::args().collect();
    let n: u32 = args[1]
        .trim()
        .parse()
        .expect("Wanted a number");
    println!("Upper limit is {}", n);
}

fn primeSieve
