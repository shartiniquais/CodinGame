use std::io::{self, Write};

/**
 * /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 * // Function narrow_dimension:                                                                                      //
 * //   Updates the search interval in one dimension                                                                  //
 * //   based on the feedback and the comparison between                                                              //
 * //   the previous position (x0 or y0) and the current position (x or y).                                           //
 * //                                                                                                                 //
 * // Parameters:                                                                                                     //
 * //   prev : previous position on the axis (x0 or y0)                                                               //
 * //   current : current position on the axis (x or y)                                                               //
 * //   min_ : current lower bound (x_min or y_min)                                                                   //
 * //   max_ : current upper bound (x_max or y_max)                                                                   //
 * //   info : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                       //
 * //                                                                                                                 //
 * // For SAME, if (x0+x) (or y0+y) is even, the bomb is exactly in the middle.                                      //
 * // For WARMER/COLDER, we deduce which side of the interval to keep                                                //
 * /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 */
fn narrow_dimension(prev: i32, current: i32, min_: i32, max_: i32, info: &str) -> (i32, i32) {
    let sum = prev + current;
    let mut min_ = min_;
    let mut max_ = max_;

    match info {
        "SAME" => {
            if sum % 2 == 0 {
                let middle = sum / 2;
                min_ = middle;
                max_ = middle;
            }
        }
        "WARMER" => {
            if current > prev {
                let new_lower = sum / 2 + 1;
                if new_lower > min_ {
                    min_ = new_lower;
                }
            } else if current < prev {
                let new_upper = if sum % 2 == 0 {
                    sum / 2 - 1
                } else {
                    sum / 2
                };
                if new_upper < max_ {
                    max_ = new_upper;
                }
            }
        }
        "COLDER" => {
            if current > prev {
                let new_upper = if sum % 2 == 0 {
                    sum / 2 - 1
                } else {
                    sum / 2
                };
                if new_upper < max_ {
                    max_ = new_upper;
                }
            } else if current < prev {
                let new_lower = sum / 2 + 1;
                if new_lower > min_ {
                    min_ = new_lower;
                }
            }
        }
        _ => {}
    }

    (min_, max_)
}

/**
 * ////////////////////////////////////////////////////////////////
 * // Function narrow:                                           //
 * // Applies narrow_dimension on x as long as                   //
 * // the horizontal interval is not reduced to a single value,  //
 * // then on y if x is already determined.                      //
 * ////////////////////////////////////////////////////////////////
 */
fn narrow(
    x0: i32,
    y0: i32,
    x: i32,
    y: i32,
    x_min: i32,
    x_max: i32,
    y_min: i32,
    y_max: i32,
    info: &str,
) -> (i32, i32, i32, i32) {
    eprintln!(
        "narrow: x0: {} y0: {} x_min: {} x_max: {} y_min: {} y_max: {} info: {}",
        x0, y0, x_min, x_max, y_min, y_max, info
    );

    let (mut x_min, mut x_max, mut y_min, mut y_max) = (x_min, x_max, y_min, y_max);

    if x_min != x_max {
        let (new_min, new_max) = narrow_dimension(x0, x, x_min, x_max, info);
        x_min = new_min;
        x_max = new_max;
    } else if y_min != y_max {
        let (new_min, new_max) = narrow_dimension(y0, y, y_min, y_max, info);
        y_min = new_min;
        y_max = new_max;
    }

    eprintln!(
        "narrow : x_min: {} x_max: {} y_min: {} y_max: {}",
        x_min, x_max, y_min, y_max
    );

    (x_min, x_max, y_min, y_max)
}

fn read_line() -> String {
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    input.trim().to_string()
}

fn main() {
    let dims: Vec<i32> = read_line().split_whitespace().map(|x| x.parse().unwrap()).collect();
    let (w, h) = (dims[0], dims[1]);

    let _n: i32 = read_line().parse().unwrap(); // max turns, unused

    let pos: Vec<i32> = read_line().split_whitespace().map(|x| x.parse().unwrap()).collect();
    let (mut x0, mut y0) = (pos[0], pos[1]);
    let (mut x, mut y) = (x0, y0);

    let (mut x_min, mut x_max) = (0, w - 1);
    let (mut y_min, mut y_max) = (0, h - 1);

    loop {
        let mut info = read_line();

        let (new_x_min, new_x_max, new_y_min, new_y_max) =
            narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, &info);
        x_min = new_x_min;
        x_max = new_x_max;
        y_min = new_y_min;
        y_max = new_y_max;

        eprintln!(
            "narrow results: x_min: {} x_max: {} y_min: {} y_max: {}",
            x_min, x_max, y_min, y_max
        );

        x0 = x;
        y0 = y;

        if x_min != x_max {
            if x0 == 0 && x_max + x_min + 1 != w {
                x = (3 * x_min + x_max) / 2 - x0;
            } else if x0 == w - 1 && x_max + x_min + 1 != w {
                x = (x_min + 3 * x_max) / 2 - x0;
            } else {
                x = x_max + x_min - x0;
            }

            if x == x0 {
                x += 1;
            }

            if x < 0 {
                x = 0;
            }
            if x > w - 1 {
                x = w - 1;
            }
        } else {
            if x != x_min {
                x = x_min;
                x0 = x;
                println!("{} {}", x, y);
                info = read_line(); // read again for y axis
            }

            if y_min != y_max {
                if y0 == 0 && y_max + y_min + 1 != h {
                    y = (3 * y_min + y_max) / 2 - y0;
                } else if y0 == h - 1 && y_max + y_min + 1 != h {
                    y = (y_min + 3 * y_max) / 2 - y0;
                } else {
                    y = y_max + y_min - y0;
                }

                if y == y0 {
                    y += 1;
                }

                if y < 0 {
                    y = 0;
                }
                if y > h - 1 {
                    y = h - 1;
                }
            } else {
                y = y_min;
            }
        }

        println!("{} {}", x, y);
    }
}
