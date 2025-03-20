input = new Scanner(System.in);

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/


// game loop
while (true) {
    int biggest = 0
    int num = 0
    for (i = 0; i < 8; ++i) {
        mountainH = input.nextInt() // represents the height of one mountain.
        if (mountainH > biggest) {
            biggest = mountainH
            num = i
        }
    }

    // Write an action using println
    // To debug: System.err << "Debug messages...\n"

    println num // The index of the mountain to fire on.
}