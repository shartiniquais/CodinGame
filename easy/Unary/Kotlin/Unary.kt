import java.util.*
import java.io.*
import java.math.*

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fun main(args : Array<String>) {
    val input = Scanner(System.`in`)
    val msg = input.nextLine()

    var output = ""
    var bn = ""
    var b = '\u0000'

    for (i in 0 until msg.length) {
        // Convert the character to ascii
        val ascii = msg[i].code
        // Convert the ascii to binary
        val binary_value = Integer.toBinaryString(ascii)
        // Add leading zeros to make it 7 bits
        val binary = binary_value.padStart(7, '0')
        // Append the binary value to the binary string
        bn += binary
    }

    for (i in 0 until bn.length) {
        var c = bn[i]
        if (c != b){
            if (c == '0'){
                output += " 00 "
            } else {
                output += " 0 "
            }
            b = c
        } 
        output += "0"
    }
    // trim output
    output = output.trim()

    println(output)
}