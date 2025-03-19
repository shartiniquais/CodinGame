import java.util.*
import java.io.*
import java.math.*

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fun main(args : Array<String>) {
    val input = Scanner(System.`in`)
    val n = input.nextInt() // the number of temperatures to analyse

    if (n == 0) {
        println("0")
        return
    }

    // variable to store all temperatures
    var values = mutableListOf<Int>()

    for (i in 0 until n) {
        val t = input.nextInt() // a temperature expressed as an integer ranging from -273 to 5526
        values.add(t)
    }

    var min_value = values[0]
    var min_distance = Math.abs(min_value)

    for (i in 1 until n) {
        val distance = Math.abs(values[i])
        if (distance < min_distance || (distance == min_distance && values[i] > min_value)) {
            min_distance = distance
            min_value = values[i]
        }
    }

    println(min_value)
}