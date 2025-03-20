import std;

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/

void main()
{

    // game loop
    while (1) {
        int biggest = 0;
        int num = 0;

        for (int i = 0; i < 8; i++) {
            int mountainH = readln.strip.to!int;

            if (mountainH > biggest) {
                biggest = mountainH;
                num = i;
            }
        }
        writeln(num);
    }
}