<?php
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Function narrow_dimension:                                                                                      //
//   Updates the search interval in one dimension                                                                  //
//   based on the feedback and the comparison between                                                              //
//   the previous position (x0 or y0) and the current position (x or y).                                           //
//                                                                                                                 //
// Parameters:                                                                                                     //
//   $prev : previous position on the axis (x0 or y0)                                                              //
//   $current : current position on the axis (x or y)                                                              //
//   $min : current lower bound (x_min or y_min)                                                                   //
//   $max : current upper bound (x_max or y_max)                                                                   //
//   $info : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                      //
//                                                                                                                 //
// For SAME, if (x0+x) (or y0+y) is even, the bomb is exactly in the middle.                                       //
// For WARMER/COLDER, we deduce which side of the interval to keep                                                 //
//   - WARMER: if moved closer to bomb, keep nearer half                                                            //
//   - COLDER: if moved further, discard nearer half                                                               //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function narrow_dimension($prev, $current, $min, $max, $info) {
    $sum = $prev + $current;
    if ($info === "SAME") {
        if ($sum % 2 == 0) {
            $middle = intdiv($sum, 2);
            $min = $middle;
            $max = $middle;
        }
    } elseif ($info === "WARMER") {
        if ($current > $prev) {
            $new_lower = intdiv($sum, 2) + 1;
            if ($new_lower > $min) {
                $min = $new_lower;
            }
        } elseif ($current < $prev) {
            $new_upper = ($sum % 2 == 0) ? intdiv($sum, 2) - 1 : intdiv($sum, 2);
            if ($new_upper < $max) {
                $max = $new_upper;
            }
        }
    } elseif ($info === "COLDER") {
        if ($current > $prev) {
            $new_upper = ($sum % 2 == 0) ? intdiv($sum, 2) - 1 : intdiv($sum, 2);
            if ($new_upper < $max) {
                $max = $new_upper;
            }
        } elseif ($current < $prev) {
            $new_lower = intdiv($sum, 2) + 1;
            if ($new_lower > $min) {
                $min = $new_lower;
            }
        }
    }

    return [$min, $max];
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
function narrow($x0, $y0, $x, $y, $x_min, $x_max, $y_min, $y_max, $info) {
    error_log("narrow: x0=$x0 y0=$y0 x_min=$x_min x_max=$x_max y_min=$y_min y_max=$y_max info=$info");
    if ($x_min != $x_max) {
        [$x_min, $x_max] = narrow_dimension($x0, $x, $x_min, $x_max, $info);
    } elseif ($y_min != $y_max) {
        [$y_min, $y_max] = narrow_dimension($y0, $y, $y_min, $y_max, $info);
    }
    error_log("narrow : x_min=$x_min x_max=$x_max y_min=$y_min y_max=$y_max");

    return [$x_min, $x_max, $y_min, $y_max];
}

// Read input
fscanf(STDIN, "%d %d", $w, $h);
fscanf(STDIN, "%d", $n);
fscanf(STDIN, "%d %d", $x0, $y0);

$x = $x0;
$y = $y0;

$x_min = 0;
$x_max = $w - 1;
$y_min = 0;
$y_max = $h - 1;

while (true) {
    fscanf(STDIN, "%s", $info);

    [$x_min, $x_max, $y_min, $y_max] = narrow($x0, $y0, $x, $y, $x_min, $x_max, $y_min, $y_max, $info);

    $x0 = $x;
    $y0 = $y;

    if ($x_min != $x_max) {
        if ($x0 == 0 && $x_max + $x_min + 1 != $w) {
            $x = intdiv(3 * $x_min + $x_max, 2) - $x0;
        } elseif ($x0 == $w - 1 && $x_max + $x_min + 1 != $w) {
            $x = intdiv($x_min + 3 * $x_max, 2) - $x0;
        } else {
            $x = $x_max + $x_min - $x0;
        }

        if ($x == $x0) {
            $x = $x0 + 1;
        }

        if ($x < 0) $x = 0;
        if ($x > $w - 1) $x = $w - 1;
    } else {
        if ($x != $x_min) {
            $x = $x_min;
            $x0 = $x;
            echo "$x $y\n";
            fscanf(STDIN, "%s", $info);
        }

        if ($y_min != $y_max) {
            if ($y0 == 0 && $y_max + $y_min + 1 != $h) {
                $y = intdiv(3 * $y_min + $y_max, 2) - $y0;
            } elseif ($y0 == $h - 1 && $y_max + $y_min + 1 != $h) {
                $y = intdiv($y_min + 3 * $y_max, 2) - $y0;
            } else {
                $y = $y_max + $y_min - $y0;
            }

            if ($y == $y0) {
                $y += 1;
            }

            if ($y < 0) $y = 0;
            if ($y > $h - 1) $y = $h - 1;
        } else {
            $y = $y_min;
        }
    }

    echo "$x $y\n";
}
?>
