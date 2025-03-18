import java.util.*

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/
fun main(args: Array<String>) {
    val input = Scanner(System.`in`)

    // game loop
    while (true) {
        val enemy1 = input.next() // name of enemy 1
        val dist1 = input.nextInt() // distance to enemy 1
        val enemy2 = input.next() // name of enemy 2
        val dist2 = input.nextInt() // distance to enemy 2

        // Determine which enemy is closer and print its name
        println(if (dist1 < dist2) enemy1 else enemy2)
    }
}