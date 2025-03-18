input = new Scanner(System.in)

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/

// game loop
while (true) {
    // Read the name and distance of enemy 1
    enemy1 = input.next() // name of enemy 1
    dist1 = input.nextInt() // distance to enemy 1
    
    // Read the name and distance of enemy 2
    enemy2 = input.next() // name of enemy 2
    dist2 = input.nextInt() // distance to enemy 2

    // Determine which enemy is closer and print its name
    println dist1 < dist2 ? enemy1 : enemy2
}