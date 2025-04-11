import math._
import scala.util._
import scala.io.StdIn._

object Player extends App {

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
    * //   min : current lower bound (x_min or y_min)                                                                    //
    * //   max : current upper bound (x_max or y_max)                                                                    //
    * //   info : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                       //
    * /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    def narrowDimension(prev: Int, current: Int, min: Int, max: Int, info: String): (Int, Int) = {
        val sum = prev + current
        var newMin = min
        var newMax = max

        info match {
            case "SAME" =>
                if (sum % 2 == 0) {
                    val middle = sum / 2
                    newMin = middle
                    newMax = middle
                }

            case "WARMER" =>
                if (current > prev) {
                    val newLower = (sum / 2) + 1
                    if (newLower > newMin) newMin = newLower
                } else if (current < prev) {
                    val newUpper = if (sum % 2 == 0) (sum / 2) - 1 else sum / 2
                    if (newUpper < newMax) newMax = newUpper
                }

            case "COLDER" =>
                if (current > prev) {
                    val newUpper = if (sum % 2 == 0) (sum / 2) - 1 else sum / 2
                    if (newUpper < newMax) newMax = newUpper
                } else if (current < prev) {
                    val newLower = (sum / 2) + 1
                    if (newLower > newMin) newMin = newLower
                }

            case _ => // UNKNOWN or default, do nothing
        }

        (newMin, newMax)
    }

    /**
    * ////////////////////////////////////////////////////////////////
    * // Function narrow:                                           //
    * // Applies narrow_dimension on x as long as                   //
    * // the horizontal interval is not reduced to a single value,  //
    * // then on y if x is already determined.                      //
    * ////////////////////////////////////////////////////////////////
    */
    def narrow(x0: Int, y0: Int, x: Int, y: Int, 
            xMin: Int, xMax: Int, yMin: Int, yMax: Int, info: String): (Int, Int, Int, Int) = {
        Console.err.println(s"narrow: x0: $x0 y0: $y0 x_min: $xMin x_max: $xMax y_min: $yMin y_max: $yMax info: $info")

        var (newXMin, newXMax) = (xMin, xMax)
        var (newYMin, newYMax) = (yMin, yMax)

        if (xMin != xMax) {
            val (min, max) = narrowDimension(x0, x, xMin, xMax, info)
            newXMin = min
            newXMax = max
        } else if (yMin != yMax) {
            val (min, max) = narrowDimension(y0, y, yMin, yMax, info)
            newYMin = min
            newYMax = max
        }

        Console.err.println(s"narrow : x_min: $newXMin x_max: $newXMax y_min: $newYMin y_max: $newYMax")
        (newXMin, newXMax, newYMin, newYMax)
    }
    
    val Array(w, h) = readLine.split(" ").map(_.toInt)
    val _ = readLine.toInt
    val Array(x0Start, y0Start) = readLine.split(" ").map(_.toInt)

    var x0 = x0Start
    var y0 = y0Start
    var x = x0
    var y = y0

    var xMin = 0
    var xMax = w - 1
    var yMin = 0
    var yMax = h - 1

    while (true) {
        var info = readLine

        val (newXMin, newXMax, newYMin, newYMax) = narrow(x0, y0, x, y, xMin, xMax, yMin, yMax, info)
        xMin = newXMin
        xMax = newXMax
        yMin = newYMin
        yMax = newYMax

        Console.err.println(s"narrow results: x_min: $xMin x_max: $xMax y_min: $yMin y_max: $yMax")

        x0 = x
        y0 = y

        if (xMin != xMax) {
            if (x0 == 0 && xMax + xMin + 1 != w) {
                x = (3 * xMin + xMax) / 2 - x0
            } else if (x0 == w - 1 && xMax + xMin + 1 != w) {
                x = (xMin + 3 * xMax) / 2 - x0
            } else {
                x = xMax + xMin - x0
            }

            if (x == x0) x += 1
            if (x < 0) x = 0
            if (x > w - 1) x = w - 1
        } else {
            if (x != xMin) {
                x = xMin
                x0 = x
                println(s"$x $y")
                info = readLine
            }

            if (yMin != yMax) {
                if (y0 == 0 && yMax + yMin + 1 != h) {
                    y = (3 * yMin + yMax) / 2 - y0
                } else if (y0 == h - 1 && yMax + yMin + 1 != h) {
                    y = (yMin + 3 * yMax) / 2 - y0
                } else {
                    y = yMax + yMin - y0
                }

                if (y == y0) y += 1
                if (y < 0) y = 0
                if (y > h - 1) y = h - 1
            } else {
                y = yMin
            }
        }

        println(s"$x $y")
    }
}
