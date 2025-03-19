use std::io;

macro_rules! parse_input {
    ($x:expr, $t:ident) => ($x.trim().parse::<$t>().unwrap_or_else(|_| {
        eprintln!("Invalid input: {}", $x.trim());
        std::process::exit(1);
    }))
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fn main() {
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let n = parse_input!(input_line, i32); // the number of temperatures to analyse

    if n == 0 {
        println!("0");
        return;
    }

    let mut min = 5526;
    let mut min_abs = 5526;

    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let temperatures = input_line.trim().split_whitespace();

    for temp in temperatures {
        let t = temp.parse::<i32>().unwrap_or_else(|_| {
            eprintln!("Invalid temperature: {}", temp);
            std::process::exit(1);
        });

        if t.abs() < min_abs || (t.abs() == min_abs && t > min) {
            min = t;
            min_abs = t.abs();
        }
    }

    println!("{}", min);
}