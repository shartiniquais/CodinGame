#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

int main()
{
    int w, h;
    scanf("%d%d", &w, &h);
    
    int _; // maximum number of turns before game over. (not used)
    scanf("%d", &_);

    int x0, y0;
    scanf("%d%d", &x0, &y0);

    int left, right, up, down;
    left = 0;
    right = w - 1;
    up = 0;
    down = h - 1;

    // game loop
    while (1) {
        char bomb_dir[4];
        scanf("%s", bomb_dir);

        if (strstr(bomb_dir, "U") != NULL) {
            down = y0 - 1;
        }
        else if (strstr(bomb_dir, "D") != NULL) {
            up = y0 + 1;
        }

        if (strstr(bomb_dir, "L") != NULL) {
            right = x0 - 1;
        }
        else if (strstr(bomb_dir, "R") != NULL) {
            left = x0 + 1;
        }

        // new position
        x0 = (left + right) / 2;
        y0 = (up + down) / 2;

        printf("%d %d\n", x0, y0);
    }

    return 0;
}