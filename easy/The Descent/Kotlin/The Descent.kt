import java.util.*
import java.io.*
import java.math.*

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/
fun main(args : Array<String>) {
    val input = Scanner(System.`in`)

    // game loop
    while (true) {
        var biggest = 0;
        var num = 0;

        for (i in 0 until 8) {
            val mountainH = input.nextInt() // represents the height of one mountain.
            if (biggest < mountainH){
                biggest = mountainH;
                num = i;
            }        
        }

        // Write an action using println()
        // To debug: System.err.println("Debug messages...");

        println(num) // The index of the mountain to fire on.
    }
}