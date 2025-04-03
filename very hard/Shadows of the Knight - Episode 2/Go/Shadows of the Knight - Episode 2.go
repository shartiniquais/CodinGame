package main

import (
    "fmt"
    "os"
    "strconv"
    "strings"
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Function narrow_dimension:                                                                                      //
//   Updates the search interval in one dimension                                                                  //
//   based on the feedback and the comparison between                                                              //
//   the previous position (x0 or y0) and the current position (x or y).                                           //
//                                                                                                                 //
// Parameters:                                                                                                     //
//   $1 : previous position on the axis (x0 or y0)                                                                 //
//   $2 : current position on the axis (x or y)                                                                    //
//   $3 : current lower bound (x_min or y_min)                                                                     //
//   $4 : current upper bound (x_max or y_max)                                                                     //
//   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         //
//                                                                                                                 //
// For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              //
// exactly in the middle.                                                                                          //
//                                                                                                                 //
// For WARMER/COLDER, we deduce which side of the interval to keep:                                                //
//   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               //
//     so new_min = ((x0+x)/2) + 1.                                                                                //
//   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    //
//                                                                                                                 //
// The same reasoning applies for y.                                                                               //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func narrow_dimension(prev int, current int, min int, max int, info string) string {
    if info == "SAME" {
        sum := prev + current
        if sum%2 == 0 {
            middle := sum / 2
            min = middle
            max = middle
        }
    } else if info == "WARMER" {
        if current > prev {
            sum := prev + current
            new_lower := (sum / 2) + 1
            if new_lower > min {
                min = new_lower
            }
        } else if current < prev {
            sum := prev + current
            var new_upper int
            if sum%2 == 0 {
                new_upper = sum/2 - 1
            } else {
                new_upper = sum / 2
            }
            if new_upper < max {
                max = new_upper
            }
        }
    } else if info == "COLDER" {
        if current > prev {
            sum := prev + current
            var new_upper int
            if sum%2 == 0 {
                new_upper = sum/2 - 1
            } else {
                new_upper = sum / 2
            }
            if new_upper < max {
                max = new_upper
            }
        } else if current < prev {
            sum := prev + current
            new_lower := (sum / 2) + 1
            if new_lower > min {
                min = new_lower
            }
        }
    }
    return fmt.Sprintf("%d %d", min, max)
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
func narrow(x0, y0, x, y, x_min, x_max, y_min, y_max int, info string) string {
    fmt.Fprintln(os.Stderr, "narrow: x0:", x0, "y0:", y0, "x_min:", x_min, "x_max:", x_max, "y_min:", y_min, "y_max:", y_max, "info:", info)
    if x_min != x_max {
        parts := strings.Split(narrow_dimension(x0, x, x_min, x_max, info), " ")
        x_min, _ = strconv.Atoi(parts[0])
        x_max, _ = strconv.Atoi(parts[1])
    } else if y_min != y_max {
        parts := strings.Split(narrow_dimension(y0, y, y_min, y_max, info), " ")
        y_min, _ = strconv.Atoi(parts[0])
        y_max, _ = strconv.Atoi(parts[1])
    }
    fmt.Fprintln(os.Stderr, "narrow results: x_min:", x_min, "x_max:", x_max, "y_min:", y_min, "y_max:", y_max)
    return fmt.Sprintf("%d %d %d %d", x_min, x_max, y_min, y_max)
}

func main() {
    var w, h int
    fmt.Scan(&w, &h)

    var notUsed int
    fmt.Scan(&notUsed)

    var x0, y0 int
    fmt.Scan(&x0, &y0)
    x := x0
    y := y0

    x_min := 0
    x_max := w - 1
    y_min := 0
    y_max := h - 1

    //////////////////////////////////////////////////
    // Main game loop.                              //
    // Perform a binary search first on the x-axis, //
    // then on the y-axis when x is determined.     //
    //////////////////////////////////////////////////
    for {
        var info string
        fmt.Scan(&info)

        bounds := strings.Split(narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info), " ")
        x_min, _ = strconv.Atoi(bounds[0])
        x_max, _ = strconv.Atoi(bounds[1])
        y_min, _ = strconv.Atoi(bounds[2])
        y_max, _ = strconv.Atoi(bounds[3])

        x0 = x
        y0 = y

        if x_min != x_max {
            if x0 == 0 && x_max+x_min+1 != w {
                x = (3*x_min + x_max)/2 - x0
            } else if x0 == w-1 && x_max+x_min+1 != w {
                x = (x_min + 3*x_max)/2 - x0
            } else {
                x = x_max + x_min - x0
            }

            if x == x0 {
                x = x0 + 1
            }

            if x < 0 {
                x = 0
            }
            if x > w-1 {
                x = w - 1
            }
        } else {
            if x != x_min {
                x = x_min
                x0 = x
                fmt.Println(x, y)
                fmt.Scan(&info)
            }

            if y_min != y_max {
                if y0 == 0 && y_max+y_min+1 != h {
                    y = (3*y_min + y_max)/2 - y0
                } else if y0 == h-1 && y_max+y_min+1 != h {
                    y = (y_min + 3*y_max)/2 - y0
                } else {
                    y = y_max + y_min - y0
                }

                if y == y0 {
                    y = y + 1
                }

                if y < 0 {
                    y = 0
                }
                if y > h-1 {
                    y = h - 1
                }
            } else {
                y = y_min
            }
        }

        fmt.Println(x, y)
    }
}
