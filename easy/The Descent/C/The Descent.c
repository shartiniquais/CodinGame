#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/

int main()
{

    // game loop
    while (1) {
        int biggest=0;
        int num=0;
        for (int i = 0; i < 8; i++) {
            // represents the height of one mountain.
            int mountain_h;
            scanf("%d", &mountain_h);
            if (mountain_h>biggest){
                biggest=mountain_h;
                num=i;
            }
        }

        printf("%d\n",num);


    }

    return 0;
}