import scala.io.StdIn._

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/
object Player extends App {

    // game loop
    while(true) {
        val enemy1 = readLine // name of enemy 1
        val dist1 = readLine.toInt // distance to enemy 1
        val enemy2 = readLine // name of enemy 2
        val dist2 = readLine.toInt // distance to enemy 2
        
        // Write an action using println
        // To debug: Console.err.println("Debug messages...")
        
        // Determine which enemy is closer and print its name
        println(if (dist1 < dist2) enemy1 else enemy2)
    }
}