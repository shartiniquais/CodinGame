using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Player
{
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
    static string narrow_dimension(int prev, int current, int min, int max, string info)
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
                // Moving to the right: the bomb is to the right of the middle.
                int sum = prev + current;
                int new_lower = (sum / 2) + 1;
                if (new_lower > min)
                {
                    min = new_lower;
                }
            }
            else if (current < prev)
            {
                // Moving to the left: the bomb is to the left of the middle.
                int sum = prev + current;
                int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2);
                if (new_upper < max)
                {
                    max = new_upper;
                }
            }
        }
        else if (info == "COLDER")
        {
            if (current > prev)
            {
                // Moving to the right: the bomb is to the left of the middle.
                int sum = prev + current;
                int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2);
                if (new_upper < max)
                {
                    max = new_upper;
                }
            }
            else if (current < prev)
            {
                // Moving to the left: the bomb is to the right of the middle.
                int sum = prev + current;
                int new_lower = (sum / 2) + 1;
                if (new_lower > min)
                {
                    min = new_lower;
                }
            }
        }
        // returns the new interval
        return min + " " + max;
    }

    ////////////////////////////////////////////////////////////////
    // Function narrow:                                           //
    // Applies narrow_dimension on x as long as                   //
    // the horizontal interval is not reduced to a single value,  //
    // then on y if x is already determined.                      //
    ////////////////////////////////////////////////////////////////
    static string narrow(int x0, int y0, int x, int y, int x_min, int x_max, int y_min, int y_max, string info)
    {
        Console.Error.WriteLine("narrow: x0: " + x0 + " y0: " + y0 + " x_min: " + x_min + " x_max: " + x_max + " y_min: " + y_min + " y_max: " + y_max + " info: " + info);
        if (x_min != x_max)
        {
            string[] x_interval = narrow_dimension(x0, x, x_min, x_max, info).Split(' ');
            x_min = int.Parse(x_interval[0]);
            x_max = int.Parse(x_interval[1]);
        }
        else if (y_min != y_max)
        {
            string[] y_interval = narrow_dimension(y0, y, y_min, y_max, info).Split(' ');
            y_min = int.Parse(y_interval[0]);
            y_max = int.Parse(y_interval[1]);
        }
        Console.Error.WriteLine("narrow : x_min: " + x_min + " x_max: " + x_max + " y_min: " + y_min + " y_max: " + y_max);

        return x_min + " " + x_max + " " + y_min + " " + y_max;
    }


    static void Main(string[] args)
    {
        string[] inputs;
        inputs = Console.ReadLine().Split(' ');
        int w = int.Parse(inputs[0]); // width of the building.
        int h = int.Parse(inputs[1]); // height of the building.


        int _ = int.Parse(Console.ReadLine()); // maximum number of turns before game over. (not used)

        // Read the starting position.
        inputs = Console.ReadLine().Split(' ');
        int x0 = int.Parse(inputs[0]);
        int y0 = int.Parse(inputs[1]);
        int x = x0;
        int y = y0;

        // Initializing the bounds for x and y.
        int x_min = 0;
        int x_max = w - 1;
        int y_min = 0;
        int y_max = h - 1;

        //////////////////////////////////////////////////
        // Main game loop.                              //
        // Perform a binary search first on the x-axis, //
        // then on the y-axis when x is determined.     //
        //////////////////////////////////////////////////
        while (true)
        {
            // Read the info
            string info = Console.ReadLine();

            // Update the bounds based on the feedback.
            string[] bounds = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info).Split(' ');
            x_min = int.Parse(bounds[0]);
            x_max = int.Parse(bounds[1]);
            y_min = int.Parse(bounds[2]);
            y_max = int.Parse(bounds[3]);

            Console.Error.WriteLine("narrow results: x_min: " + x_min + " x_max: " + x_max + " y_min: " + y_min + " y_max: " + y_max);

            // Update previous positions.
            x0 = x;
            y0 = y;

            // Binary search on the x-axis.
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
                    x = x_max + x_min - x0;
                }

                // Avoid staying on the same move.
                if (x == x0)
                {
                    x = x0 + 1;
                }

                // Ensure x is within [0, w-1].
                if (x < 0) { x = 0; }
                if (x > (w - 1)) { x = w - 1; }
            }
            else
            {
                // If x is fixed, ensure it matches x_min
                if (x != x_min)
                {
                    x = x_min;
                    x0 = x;
                    Console.WriteLine("{0} {1}", x, y);
                    info = Console.ReadLine();
                }

                // Binary search on the vertical axis.
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

                    // Avoid staying on the same move.
                    if (y == y0)
                    {
                        y = y + 1;
                    }

                    // Ensure y is within [0, h-1].
                    if (y < 0) { y = 0; }
                    if (y > (h - 1)) { y = h - 1; }
                }
                else
                {
                    y = y_min;
                }
            }
            Console.WriteLine("{0} {1}", x, y);
        }
    }
}