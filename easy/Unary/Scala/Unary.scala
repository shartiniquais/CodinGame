import math._
import scala.util._
import scala.io.StdIn._

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
object Solution extends App {
    val msg = readLine
    var output = ""
    var bn = ""
    var b = '\u0000'
    
    for (i <- 0 until msg.length) {
        // convert to ascii
        val ascii = msg(i).toInt
        // convert to binary
        val binary = ascii.toBinaryString
        // add leading zeros
        val binary2 = "0" * (7 - binary.length) + binary
        // add binary to bn
        bn += binary2
    }

    for (i <- 0 until bn.length) {
        val c = bn(i)
        if (c != b){
            if (c == '0') {
                output += " 00 "
            } else {
                output += " 0 "
            }
            b = c
        }
        output += "0"
    }

    println(output.trim)
}