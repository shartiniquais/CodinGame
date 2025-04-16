import java.util.*
import java.io.*
import java.math.*

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fun main(args : Array<String>) {
    val input = Scanner(System.`in`)
    val W = input.nextInt() // width of the building.
    val H = input.nextInt() // height of the building.
    val N = input.nextInt() // maximum number of turns before game over.
    var X0 = input.nextInt()
    var Y0 = input.nextInt()

    var left = 0
    var right = W - 1
    var up = 0
    var down = H - 1

    // game loop
    while (true) {
        val bombDir = input.next() // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        if (bombDir.contains("U")) {
            down = Y0 - 1
        } else if (bombDir.contains("D")) {
            up = Y0 + 1
        }
        if (bombDir.contains("L")) {
            right = X0 - 1
        } else if (bombDir.contains("R")) {
            left = X0 + 1
        }

        X0 = (left + right) / 2
        Y0 = (up + down) / 2

        // the location of the next window Batman should jump to.
        println("$X0 $Y0")
    }
}