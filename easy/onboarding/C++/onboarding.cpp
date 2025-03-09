#include <iostream>
#include <string>

using namespace std;

/**
 * CodinGame planet is being attacked by slimy insectoid aliens.
 * <---
 * Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
 **/

int main()
{
    // game loop
    while (true) {
        string enemy1; // name of enemy 1
        int dist1; // distance to enemy 1
        string enemy2; // name of enemy 2
        int dist2; // distance to enemy 2

        cin >> enemy1 >> dist1;
        cin.ignore();
        cin >> enemy2 >> dist2;
        cin.ignore();

        // Determine which enemy is closer and print its name
        cout << (dist1 < dist2 ? enemy1 : enemy2) << endl;
    }
}