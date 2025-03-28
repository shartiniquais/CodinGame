#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <string.h>

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
char *narrow_dimension(int prev, int current, int min, int max, char *info)
{
    if (strcmp(info, "SAME") == 0)
    {
        int sum = prev + current;
        if (sum % 2 == 0)
        {
            int middle = sum / 2;
            min = middle;
            max = middle;
        }
    }
    else if (strcmp(info, "WARMER") == 0)
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
    else if (strcmp(info, "COLDER") == 0)
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
    // returns concatenation of min and max
    char *return_value = (char *)malloc(100);
    sprintf(return_value, "%d %d", min, max);
    return return_value;
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
char *narrow(int x0, int y0, int x, int y, int x_min, int y_min, int x_max, int y_max, char *info)
{
    fprintf(stderr, "narrow: x0=%d, y0=%d, x=%d, y=%d, x_min=%d, y_min=%d, x_max=%d, y_max=%d, info=%s\n", x0, y0, x, y, x_min, y_min, x_max, y_max, info);
    if (x_min != x_max)
    {
        sscanf(narrow_dimension(x0, x, x_min, x_max, info), "%d %d", &x_min, &x_max);
    }
    else if (y_min != y_max)
    {
        sscanf(narrow_dimension(y0, y, y_min, y_max, info), "%d %d", &y_min, &y_max);   
    }
    fprintf(stderr, "narrow: x_min=%d, y_min=%d, x_max=%d, y_max=%d\n", x_min, y_min, x_max, y_max);

    char *return_value = (char *)malloc(100);
    sprintf(return_value, "%d %d %d %d", x_min, y_min, x_max, y_max);
    return return_value;
}

int main()
{
    // Reading the dimensions of the building and the maximum number of turns (not used).
    int w, h, _;

    scanf("%d%d", &w, &h);
    scanf("%d", &_);

    // Reading the starting position.
    int x0, y0;
    scanf("%d%d", &x0, &y0);
    int x = x0;
    int y = y0;

    // Initializing the bounds for x and y.
    int x_min = 0, y_min = 0;
    int x_max = w - 1, y_max = h - 1;

    //////////////////////////////////////////////////
    // Main game loop.                              //
    // Perform a binary search first on the x-axis, //
    // then on the y-axis when x is determined.     //
    //////////////////////////////////////////////////
    while (1)
    {
        // Reading the info.
        char info[10];
        scanf("%s", info);

        // Update the bounds based on the feedback.
        char *result = narrow(x0, y0, x, y, x_min, y_min, x_max, y_max, info);
        fprintf(stderr, "narrow result: %s\n", result);

        // Extract the new bounds.
        sscanf(result, "%d %d %d %d", &x_min, &y_min, &x_max, &y_max);

        // Update the previous position.
        x0 = x;
        y0 = y;

        // Binary search on the horizontal axis.
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
                printf("%d %d\n", x, y);
                scanf("%s", info);
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

        // Output the move to play.
        printf("%d %d\n", x, y);
    }

    return 0;
}