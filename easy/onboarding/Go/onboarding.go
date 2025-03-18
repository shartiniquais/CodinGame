package main

import "fmt"

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/

func main() {
    for {
        // Read the name and distance of enemy 1
        var enemy1 string
        var dist1 int
        fmt.Scan(&enemy1, &dist1)
        
        // Read the name and distance of enemy 2
        var enemy2 string
        var dist2 int
        fmt.Scan(&enemy2, &dist2)
        
        // Determine which enemy is closer and print its name
        if dist1 < dist2 {
            fmt.Println(enemy1)
        } else {
            fmt.Println(enemy2)
        }
    }
}