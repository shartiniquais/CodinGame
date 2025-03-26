use std::io;

macro_rules! parse_input {
    ($x:expr, $t:ident) => ($x.trim().parse::<$t>().unwrap())
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fn main() {
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let msg = input_line.trim_matches('\n').to_string();
    let mut output = "".to_string();
    let mut bn = "".to_string();
    let mut b: Option<char> = None;

    for c in msg.chars() {
        // convert to ascii
        let ascii = c as u8;
        // convert to binary
        let binary = format!("{:07b}", ascii);
        bn.push_str(&binary);
    }

    for c in bn.chars() {
        if Some(c) != b {
            if c == '0' {
                output.push_str(" 00 ");
            } else {
                output.push_str(" 0 ");
            }
            b = Some(c);
        }
        output.push_str("0");
    }

    println!("{}", output.trim());
}
