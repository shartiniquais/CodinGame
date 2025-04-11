import std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

void main()
{
    auto inputs = readln.split;
    int w = inputs[0].to!int; // width of the building.
    int h = inputs[1].to!int; // height of the building.
    int _ = readln.chomp.to!int; // maximum number of turns before game over. (not used)
    auto inputs2 = readln.split;
    int x0 = inputs2[0].to!int;
    int y0 = inputs2[1].to!int;

    int left = 0;
    int right = w - 1;
    int top = 0;
    int bottom = h - 1;
    

    // game loop
    while (1) {
        string bombDir = readln.chomp; // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        if (bombDir.indexOf("U") != -1) {
            bottom = y0 - 1;
        } else if (bombDir.indexOf("D") != -1) {
            top = y0 + 1;
        }
        if (bombDir.indexOf("L") != -1) {
            right = x0 - 1;
        } else if (bombDir.indexOf("R") != -1) {
            left = x0 + 1;
        }

        x0 = (left + right) / 2;
        y0 = (top + bottom) / 2;
        writeln(x0, " ", y0); // the location of the next window Batman should jump to.
    }
}