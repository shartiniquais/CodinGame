import math._
import scala.util._
import scala.io.StdIn._

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
object Solution extends App {
    val n = readLine.toInt // the number of temperatures to analyse

    if(n == 0) {
        println("0")
    } else {
        var inputs = readLine split " "

        var min = 5526
        var min_dist = 5526

        for(i <- 0 until n) {
            // t: a temperature expressed as an integer ranging from -273 to 5526
            val t = inputs(i).toInt
            val dist = abs(t)
            if(dist < min_dist || (dist == min_dist && t > 0)) {
                min = t
                min_dist = dist
            }
        }
        
        // Write an answer using println
        // To debug: Console.err.println("Debug messages...")

        println(min)
    }
}