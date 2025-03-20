#include <Foundation/Foundation.h>

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/
int main(int argc, const char * argv[]) {
    

    // game loop
    while (1) {
        int biggest = 0;
        int num = 0;
        
        for (int i = 0; i < 8; i++) {
            int mountainH; // represents the height of one mountain.
            scanf("%d", &mountainH);

            if (biggest < mountainH){
                biggest = mountainH;
                num = i;
            }
        }

        // Write an action using printf(). DON'T FORGET THE TRAILING NEWLINE \n
        // To debug: fprintf(stderr, [@"Debug messages\n" UTF8String]);

        printf("%d\n", num); // The index of the mountain to fire on.
    }
}