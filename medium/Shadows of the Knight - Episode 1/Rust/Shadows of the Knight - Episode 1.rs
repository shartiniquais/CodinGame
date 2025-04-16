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
    let inputs = input_line.split(" ").collect::<Vec<_>>();
    let w = parse_input!(inputs[0], i32); // width of the building.
    let h = parse_input!(inputs[1], i32); // height of the building.
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let n = parse_input!(input_line, i32); // maximum number of turns before game over.
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let inputs = input_line.split(" ").collect::<Vec<_>>();
    let mut x0 = parse_input!(inputs[0], i32);
    let mut y0 = parse_input!(inputs[1], i32);

    let mut left = 0;
    let mut right = w - 1;
    let mut top = 0;
    let mut bottom = h - 1;

    // game loop
    loop {
        let mut input_line = String::new();
        io::stdin().read_line(&mut input_line).unwrap();
        let bomb_dir = input_line.trim().to_string(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        if bomb_dir.contains("U") {
            bottom = y0 - 1;
        } else if bomb_dir.contains("D") {
            top = y0 + 1;
        }
        if bomb_dir.contains("L") {
            right = x0 - 1;
        } else if bomb_dir.contains("R") {
            left = x0 + 1;
        }

        x0 = (left + right) / 2;
        y0 = (top + bottom) / 2;

        println!("{} {}", x0, y0);
    }
}
