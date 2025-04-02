import std;


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
string narrow_dimension(int prev, int current, int min, int max, string info)
{
    if (info == "SAME")
    {
        int sum = prev + current;
        if (sum % 2 == 0)
        {
            int middle = sum / 2;
            min = middle;
            max = middle;
        }
    }
    else if (info == "WARMER")
    {
        if (current > prev)
        {
            int sum = prev + current;
            int new_lower = (sum / 2) + 1;
            if (new_lower > min)
                min = new_lower;
        }
        else if (current < prev)
        {
            int sum = prev + current;
            int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2);
            if (new_upper < max)
                max = new_upper;
        }
    }
    else if (info == "COLDER")
    {
        if (current > prev)
        {
            int sum = prev + current;
            int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2);
            if (new_upper < max)
                max = new_upper;
        }
        else if (current < prev)
        {
            int sum = prev + current;
            int new_lower = (sum / 2) + 1;
            if (new_lower > min)
                min = new_lower;
        }
    }
    return to!string(min) ~ " " ~ to!string(max);
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
string narrow(int x0, int y0, int x, int y, int x_min, int x_max, int y_min, int y_max, string info)
{
    stderr.writeln("narrow: x0=", x0, ", y0=", y0, ", x=", x, ", y=", y, ", x_min=", x_min, ", x_max=", x_max,
     ", y_min=", y_min, ", y_max=", y_max, ", info=", info);

    if (x_min != x_max) // If the x interval is not reduced to a single value
    {
        string new_bounds = narrow_dimension(x0, x, x_min, x_max, info);
        auto parts = new_bounds.split;
        x_min = parts[0].to!int;
        x_max = parts[1].to!int;
    }
    else // If the x interval is reduced to a single value, apply narrow_dimension on y
    {
        string new_bounds = narrow_dimension(y0, y, y_min, y_max, info);
        auto parts = new_bounds.split;
        y_min = parts[0].to!int;
        y_max = parts[1].to!int;
    }
    stderr.writeln("narrow: x_min=", x_min, ", x_max=", x_max, ", y_min=", y_min, ", y_max=", y_max);
    return to!string(x_min) ~ " " ~ to!string(x_max) ~ " " ~ to!string(y_min) ~ " " ~ to!string(y_max);
}


void main()
{
    auto inputs = readln.split;
    int w = inputs[0].to!int; // width of the building.
    int h = inputs[1].to!int; // height of the building.

    int _ = readln.chomp.to!int; // maximum number of turns before game over.(not used)

    // Read starting position
    auto inputs2 = readln.split;
    int x0 = inputs2[0].to!int;
    int y0 = inputs2[1].to!int;
    int x = x0;
    int y = y0;

    // Initialize the bounds for x and y
    int x_min = 0;
    int x_max = w - 1;
    int y_min = 0;
    int y_max = h - 1;


    //////////////////////////////////////////////////
    // Main game loop.                              //
    // Perform a binary search first on the x-axis, //
    // then on the y-axis when x is determined.     //
    //////////////////////////////////////////////////
    while (1) {
        string info = readln.chomp; // Current distance to the bomb compared to previous distance (COLDER, WARMER, SAME or UNKNOWN)

        // Update the bounds based on the info
        string new_bounds = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info);
        auto parts = new_bounds.split;
        x_min = parts[0].to!int;
        x_max = parts[1].to!int;
        y_min = parts[2].to!int;
        y_max = parts[3].to!int;

        stderr.writeln("x_min=", x_min, ", x_max=", x_max, ", y_min=", y_min, ", y_max=", y_max);

        // Upadate the previous position
        x0 = x;
        y0 = y;

        // Binary search on the x-axis
        if (x_min != x_max)
        {
            if (x0 == 0 && x_max + x_min + 1 != w)
            {
                x = (3 * x_min + x_max) / 2 - x0;
            }
            else if (x0 == w - 1 && x_max + x_min + 1 != w)
            {
                x = (x_min + 3 * x_max) / 2 - x0;
            }
            else
            {
                x = x_min + x_max - x0;
            }

            // Avoid staying on the same x position
            if (x == x0)
            {
                x = x0 + 1;
            }

            // Ensure x is within [0, w-1]
            x = max(0, min(w - 1, x));
        }
        else
        {
            // If x is fixed, ensure it matches x_min
            if (x != x_min)
            {
                x = x_min;
                x0 = x;
                writeln(to!string(x) ~ " " ~ to!string(y));
                info = readln.chomp; // Read the feedback for the fixed x position
            }

            // Binary search on the y-axis
            if (y_min != y_max)
            {
                if (y0 == 0 && y_max + y_min + 1 != h)
                {
                    y = (3 * y_min + y_max) / 2 - y0;
                }
                else if (y0 == h - 1 && y_max + y_min + 1 != h)
                {
                    y = (y_min + 3 * y_max) / 2 - y0;
                }
                else
                {
                    y = y_max + y_min - y0;
                }

                // Avoid staying on the same y position
                if (y == y0)
                {
                    y = y0 + 1;
                }

                // Ensure y is within [0, h-1]
                y = max(0, min(h - 1, y));
            }
            else
            {
                y = y_min;
            }
        }
        writeln(to!string(x) ~ " " ~ to!string(y)); // Output the next guess
    }
}