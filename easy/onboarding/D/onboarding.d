import std;

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/

void main()
{
    // game loop
    while (true) {
        string enemy1 = readln.chomp; // name of enemy 1
        int dist1 = readln.chomp.to!int; // distance to enemy 1
        string enemy2 = readln.chomp; // name of enemy 2
        int dist2 = readln.chomp.to!int; // distance to enemy 2

        // Determine which enemy is closer and print its name
        writeln(dist1 < dist2 ? enemy1 : enemy2);
    }
}