input = new Scanner(System.in);

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

w = input.nextInt() // width of the building.
h = input.nextInt() // height of the building.
_ = input.nextInt() // maximum number of turns before game over.
x0 = input.nextInt()
y0 = input.nextInt()

left = 0
right = w - 1
top = 0
bottom = h - 1

// game loop
while (true) {
    bombDir = input.next() // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if (bombDir.contains("U")) {
        bottom = y0 - 1
    } else if (bombDir.contains("D")) {
        top = y0 + 1
    }
    if (bombDir.contains("L")) {
        right = x0 - 1
    } else if (bombDir.contains("R")) {
        left = x0 + 1
    }

    y0 = (top + bottom).intdiv(2)
    x0 = (left + right).intdiv(2)

    // the location of the next window Batman should jump to.
    println (x0 + " " + y0)
}