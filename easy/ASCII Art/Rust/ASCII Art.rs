use std::io::{self, BufRead};

macro_rules! parse_input {
    ($x:expr, $t:ty) => ($x.trim().parse::<$t>().unwrap())
}

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    let l: usize = parse_input!(lines.next().unwrap().unwrap(), usize);
    let h: usize = parse_input!(lines.next().unwrap().unwrap(), usize);
    let t = lines.next().unwrap().unwrap().to_uppercase();

    let ascii_art: Vec<String> = (0..h)
        .map(|_| lines.next().unwrap().unwrap())
        .collect();

    let mut result: Vec<String> = vec![String::new(); h];

    for c in t.chars() {
        let index = if ('A'..='Z').contains(&c) {
            (c as u8 - b'A') as usize
        } else {
            26
        };

        for i in 0..h {
            let start = index * l;
            result[i].push_str(&ascii_art[i][start..(start + l)]);
        }
    }

    for line in result {
        println!("{}", line);
    }
}
