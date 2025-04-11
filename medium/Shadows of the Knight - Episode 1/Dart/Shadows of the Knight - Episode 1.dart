import 'dart:io';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    inputs = readLineSync().split(' ');
    int w = int.parse(inputs[0]); // width of the building.
    int h = int.parse(inputs[1]); // height of the building.
    int _ = int.parse(readLineSync()); // maximum number of turns before game over. (not used)
    inputs = readLineSync().split(' ');
    int x0 = int.parse(inputs[0]);
    int y0 = int.parse(inputs[1]);

    int left = 0;
    int right = w - 1;
    int top = 0;
    int bottom = h - 1;


    // game loop
    while (true) {
        String bombDir = readLineSync(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        if (bombDir.contains('U')) {
            bottom = y0 - 1;
        }
        else if (bombDir.contains('D')) {
            top = y0 + 1;
        }
        if (bombDir.contains('L')) {
            right = x0 - 1;
        }
        else if (bombDir.contains('R')) {
            left = x0 + 1;
        }

        x0 = (left + right) ~/ 2;
        y0 = (top + bottom) ~/ 2;

        print('$x0 $y0'); // the location of the next window Batman should jump to.
    }
}