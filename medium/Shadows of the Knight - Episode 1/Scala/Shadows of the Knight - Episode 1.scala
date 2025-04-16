import math._
import scala.util._
import scala.io.StdIn._

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
object Player extends App {
    // w: width of the building.
    // h: height of the building.
    val Array(w, h) = (readLine split " ").filter(_ != "").map (_.toInt)
    val _ = readLine.toInt // maximum number of turns before game over. (not used).
    var Array(x0, y0) = (readLine split " ").filter(_ != "").map (_.toInt)

    var left = 0
    var right = w - 1
    var up = 0
    var down = h - 1

    // game loop
    while(true) {
        val bombDir = readLine // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        if(bombDir.contains("U")) {
            down = y0 - 1
        } else if(bombDir.contains("D")) {
            up = y0 + 1
        }
        if(bombDir.contains("L")) {
            right = x0 - 1
        } else if(bombDir.contains("R")) {
            left = x0 + 1
        }

        x0 = (left + right) / 2
        y0 = (up + down) / 2

        println(s"$x0 $y0")
    }
}