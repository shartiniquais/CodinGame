import math._
import scala.util._
import scala.io.StdIn._

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
object Player extends App {
    val surfaceN = readLine.toInt // the number of points used to draw the surface of Mars.
    for(i <- 0 until surfaceN) {
        // landX: X coordinate of a surface point. (0 to 6999)
        // landY: Y coordinate of a surface point. By linking all the points together in a sequential fashion, you form the surface of Mars.
        val Array(landX, landY) = (readLine split " ").filter(_ != "").map (_.toInt)
    }

    // game loop
    while(true) {
        // hSpeed: the horizontal speed (in m/s), can be negative.
        // vSpeed: the vertical speed (in m/s), can be negative.
        // fuel: the quantity of remaining fuel in liters.
        // rotate: the rotation angle in degrees (-90 to 90).
        // power: the thrust power (0 to 4).
        val Array(x, y, hSpeed, vSpeed, fuel, rotate, power) = (readLine split " ").filter(_ != "").map (_.toInt)
        
        // Write an action using println
        // To debug: Console.err.println("Debug messages...")
        

        // 2 integers: rotate power. rotate is the desired rotation angle (should be 0 for level 1), power is the desired thrust power (0 to 4).
        if (vSpeed <= -40) {
            println("0 4")
        } else {
            println("0 0")
        }
    }
}