import java.util.Scanner;

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/
class Player {

    public static void main(String args[]) {
        try (Scanner in = new Scanner(System.in)) {
            // game loop
            while (true) {
                // Read the name and distance of enemy 1
                String enemy1 = in.next(); // name of enemy 1
                int dist1 = in.nextInt(); // distance to enemy 1
                
                // Read the name and distance of enemy 2
                String enemy2 = in.next(); // name of enemy 2
                int dist2 = in.nextInt(); // distance to enemy 2

                // Determine which enemy is closer and print its name
                System.out.println(dist1 < dist2 ? enemy1 : enemy2);
            }
        }
    }
}