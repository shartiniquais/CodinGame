import 'dart:io';
import 'dart:math';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
**/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Function narrow_dimension:                                                                                      //
//   Updates the search interval in one dimension                                                                  //
//   based on the feedback and the comparison between                                                              //
//   the previous position (x0 or y0) and the current position (x or y).                                           //
//                                                                                                                 //
// Parameters:                                                                                                     //
//   $1 : previous position on the axis (x0 or y0)                                                                 //
//   $2 : current position on the axis (x or y)                                                                    //
//   $3 : current lower bound (x_min or y_min)                                                                     //
//   $4 : current upper bound (x_max or y_max)                                                                     //
//   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         //
//                                                                                                                 //
// For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              //
// exactly in the middle.                                                                                          //
//                                                                                                                 //
// For WARMER/COLDER, we deduce which side of the interval to keep:                                                //
//   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               //
//     so new_min = ((x0+x)/2) + 1.                                                                                //
//   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    //
//                                                                                                                 //
// The same reasoning applies for y.                                                                               //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
String narrow_dimension(int prev, int current, int min, int max, String info)
{
    if (info == "SAME")
    {
        int sum = prev + current;
        if (sum % 2 == 0)
        {
            int middle = sum ~/ 2;
            min = middle;
            max = middle;
        }
    }
    else if (info == "WARMER")
    {
        if (current > prev)
        {
            int sum = prev + current;
            int new_lower = (sum ~/ 2) + 1;
            if (new_lower > min)
                min = new_lower;
        }
        else if (current < prev)
        {
            int sum = prev + current;
            int new_upper = (sum % 2 == 0) ? (sum ~/ 2 - 1) : (sum ~/ 2);
            if (new_upper < max)
                max = new_upper;
        }
    }
    else if (info == "COLDER")
    {
        if (current > prev)
        {
            int sum = prev + current;
            int new_upper = (sum % 2 == 0) ? (sum ~/ 2 - 1) : (sum ~/ 2);
            if (new_upper < max)
                max = new_upper;
        }
        else if (current < prev)
        {
            int sum = prev + current;
            int new_lower = (sum ~/ 2) + 1;
            if (new_lower > min)
                min = new_lower;
        }
    }
    return min.toString() + " " + max.toString();
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
String narrow(int x0, int y0, int x, int y, int x_min, int x_max, int y_min, int y_max, String info)
{
    stderr.writeln("narrow: x0 = $x0, y0 = $y0, x = $x, y = $y, x_min = $x_min, x_max = $x_max, y_min = $y_min, y_max = $y_max, info = $info");
    if (x_min != x_max)
    {
        String new_x = narrow_dimension(x0, x, x_min, x_max, info);
        List<String> parts = new_x.split(" ");
        x_min = int.parse(parts[0]);
        x_max = int.parse(parts[1]);
    }
    else
    {
        String new_y = narrow_dimension(y0, y, y_min, y_max, info);
        List<String> parts = new_y.split(" ");
        y_min = int.parse(parts[0]);
        y_max = int.parse(parts[1]);
    }
    stderr.writeln("narrow: x_min = $x_min, x_max = $x_max, y_min = $y_min, y_max = $y_max");
    return x_min.toString() + " " + x_max.toString() + " " + y_min.toString() + " " + y_max.toString();
}

void main() {
    List inputs;
    inputs = readLineSync().split(' ');
    int w = int.parse(inputs[0]); // width of the building.
    int h = int.parse(inputs[1]); // height of the building.

    int _ = int.parse(readLineSync()); // maximum number of turns before game over. (not used).

    // read the starting position
    inputs = readLineSync().split(' ');
    int x0 = int.parse(inputs[0]);
    int y0 = int.parse(inputs[1]);
    int x = x0;
    int y = y0;

    // Initialize the the bounds
    int x_min = 0;
    int x_max = w - 1;
    int y_min = 0;
    int y_max = h - 1;


    //////////////////////////////////////////////////
    // Main game loop.                              //
    // Perform a binary search first on the x-axis, //
    // then on the y-axis when x is determined.     //
    //////////////////////////////////////////////////
    while (true) {
        String info = readLineSync(); // Current distance to the bomb compared to previous distance (COLDER, WARMER, SAME or UNKNOWN)

        // update the bounds based on the info
        String new_bounds = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info);
        List<String> parts = new_bounds.split(" ");
        x_min = int.parse(parts[0]);
        x_max = int.parse(parts[1]);
        y_min = int.parse(parts[2]);
        y_max = int.parse(parts[3]);

        stderr.writeln("narrow results: x_min = $x_min, x_max = $x_max, y_min = $y_min, y_max = $y_max");

        // Update the previous position
        x0 = x;
        y0 = y;

        // Binary search on the x-axis
        if (x_min != x_max) {
            if (x0 == 0 && x_max + x_min + 1 != w) {
              x = (3 * x_min + x_max) ~/ 2 - x0;
            } else if (x0 == w - 1 && x_max + x_min + 1 != w) {
              x = (x_min + 3 * x_max) ~/ 2 - x0;
            } else {
              x = x_min + x_max - x0;
            }

            // Avoid staying on the same x position
            if (x == x0) {
                x = x0 + 1;
            }

            // Ensure x is within bounds
            x = max(0, min(x, w - 1));
        } else {
            // If x is fixed, ensure it matches x_min
            if (x != x_min) {
                x = x_min;
                x0 = x;
                print("$x $y");
                info = readLineSync(); // Read the feedback again
            }

            // Binary search on the y-axis
            if (y_min != y_max){
                if (y0 == 0 && y_max + y_min + 1 != h) {
                  y = (3 * y_min + y_max) ~/ 2 - y0;
                } else if (y0 == h - 1 && y_max + y_min + 1 != h) {
                  y = (y_min + 3 * y_max) ~/ 2 - y0;
                } else {
                  y = y_min + y_max - y0;
                }

                // Avoid staying on the same y position
                if (y == y0) {
                    y = y0 + 1;
                }

                // Ensure y is within bounds
                y = max(0, min(y, h - 1));
            } else {
                y = y_min;
            }
        }
        print("$x $y");
    }
}