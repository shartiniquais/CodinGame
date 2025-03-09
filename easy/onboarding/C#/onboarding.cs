using System;

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/
class Player
{
    static void Main(string[] args)
    {
        // game loop
        while (true)
        {
            // Read the name and distance of enemy 1
            string enemy1 = Console.ReadLine();
            int dist1 = int.Parse(Console.ReadLine());

            // Read the name and distance of enemy 2
            string enemy2 = Console.ReadLine();
            int dist2 = int.Parse(Console.ReadLine());

            // Determine which enemy is closer and print its name
            Console.WriteLine(dist1 < dist2 ? enemy1 : enemy2);
        }
    }
}