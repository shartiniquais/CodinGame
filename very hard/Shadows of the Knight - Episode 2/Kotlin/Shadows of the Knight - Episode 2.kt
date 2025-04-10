import java.util.*
import java.io.*
import java.math.*

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

/**
* Updates the search interval in one dimension
* based on the feedback and the comparison between
* the previous position (x0 or y0) and the current position (x or y).
*
* Parameters:
*   $1 : previous position on the axis (x0 or y0)
*   $2 : current position on the axis (x or y)
*   $3 : current lower bound (x_min or y_min)
*   $4 : current upper bound (x_max or y_max)
*   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")
*
* For SAME, if (x0+x) (or y0+y) is even, the bomb is
* exactly in the middle.
*
* For WARMER/COLDER, we deduce which side of the interval to keep:
*   - If x > x0 and WARMER, the bomb is to the right of the middle,
*     so new_min = ((x0+x)/2) + 1.
*   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).
*
* The same reasoning applies for y.
*/

fun narrow_dimension(prev: Int, current: Int, min: Int, max: Int, info: String): Pair<Int, Int> {
    // Initialize min and max values
    var min = min
    var max = max

    val sum = prev + current
    if (info == "SAME") {
        if (sum % 2 == 0) {
            val middle = sum / 2
            min = middle
            max = middle
        }
    } else if (info == "WARMER") {
        if (current > prev) {
            val new_lower = (sum / 2) + 1
            if (new_lower > min) {
                min = new_lower
            }
        } else if (current < prev) {
            val new_upper = sum / 2 - if (sum % 2 == 0) 1 else 0
            if (new_upper < max) {
                max = new_upper
            }
        }
    } else if (info == "COLDER") {
        if (current > prev) {
            val new_upper = sum / 2 - if (sum % 2 == 0) 1 else 0
            if (new_upper < max) {
                max = new_upper
            }
        } else if (current < prev) {
            val new_lower = (sum / 2) + 1
            if (new_lower > min) {
                min = new_lower
            }
        }
    }

    // Return the updated min and max values
    return Pair(min, max)
}

// Define a data class to represent four values
data class Quadruple<A, B, C, D>(val first: A, val second: B, val third: C, val fourth: D)

/**
 * Applies narrow_dimension on x as long as
 * the horizontal interval is not reduced to a single value,
 * then on y if x is already determined.
*/
fun narrow(x0: Int, x: Int, y0: Int, y: Int, x_min: Int, x_max: Int, y_min: Int, y_max: Int, info: String): Quadruple<Int, Int, Int, Int> {
    var x_min = x_min
    var x_max = x_max
    var y_min = y_min
    var y_max = y_max

    System.err.println("narrow: x0=$x0, x=$x, y0=$y0, y=$y, x_min=$x_min, x_max=$x_max, y_min=$y_min, y_max=$y_max")
    if (x_min != x_max) {
        val (new_x_min, new_x_max) = narrow_dimension(x0, x, x_min, x_max, info)
        x_min = new_x_min
        x_max = new_x_max
    } else if (y_min != y_max) {
        val (new_y_min, new_y_max) = narrow_dimension(y0, y, y_min, y_max, info)
        y_min = new_y_min
        y_max = new_y_max
    }
    System.err.println("narrow results: x_min=$x_min, x_max=$x_max, y_min=$y_min, y_max=$y_max")

    // Return the updated min and max values for both dimensions
    return Quadruple(x_min, x_max, y_min, y_max)
}

fun main(args : Array<String>) {
    val input = Scanner(System.`in`)
    val W = input.nextInt() // width of the building.
    val H = input.nextInt() // height of the building.

    val NOT_USED = input.nextInt() // maximum number of turns before game over. (not used)

    var x0 = input.nextInt()
    var y0 = input.nextInt()
    var x = x0
    var y = y0

    var x_min = 0
    var x_max = W - 1
    var y_min = 0
    var y_max = H - 1

    // game loop
    while (true) {
        var info = input.next() // Current distance to the bomb compared to previous distance (COLDER, WARMER, SAME or UNKNOWN)

        // Get narrow results
        val (newXMin, newXMax, newYMin, newYMax) = narrow(x0, x, y0, y, x_min, x_max, y_min, y_max, info)
        x_min = newXMin
        x_max = newXMax
        y_min = newYMin
        y_max = newYMax

        x0 = x
        y0 = y

        if (x_min != x_max){
            if (x0 == 0 && x_max + x_min + 1 != W) {
                x = (3 * x_min + x_max) / 2 - x0
            } else if (x0 == W - 1 && x_max + x_min + 1 != W) {
                x = (x_min + 3 * x_max) / 2 - x0
            } else {
                x = x_max + x_min - x0
            }

            if (x == x0) {
                x = x0 + 1
            }
            if (x < 0) {
                x = 0
            }
            if (x > W - 1) {
                x = W - 1
            }
        } else {
            if (x != x_min) {
                x = x_min
                x0 = x0
                println("$x $y")
                info = input.next()
                val (newXMin, newXMax, newYMin, newYMax) = narrow(x0, x, y0, y, x_min, x_max, y_min, y_max, info)
                x_min = newXMin
                x_max = newXMax
                y_min = newYMin
                y_max = newYMax
            }

            if (y_min != y_max) {
                if (y0 == 0 && y_max + y_min + 1 != H) {
                    y = (3 * y_min + y_max) / 2 - y0
                } else if (y0 == H - 1 && y_max + y_min + 1 != H) {
                    y = (y_min + 3 * y_max) / 2 - y0
                } else {
                    y = y_max + y_min - y0
                }

                if (y == y0) {
                    y = y0 + 1
                }
                if (y < 0) {
                    y = 0
                }
                if (y > H - 1) {
                    y = H - 1
                }
            } else {
                y = y_min
            }
        }
        println("$x $y")
    }
}