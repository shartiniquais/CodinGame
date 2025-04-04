import java.util.*

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

/**
    * IMPORTANT NOTE:
    * This code is not the best solution for the problem.
    * This code only works when coding game wants it to.
    * I needed to push it 3 times to get 100% so there's a bit of luck involved for the loop to respond in less than 150ms.
    * But at least it works. And I got 100%
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
String narrow_dimension(int prev, int current, int min, int max, String info) {
    if (info == "SAME") {
        int sum = prev + current
        if (sum % 2 == 0) {
            int middle = sum / 2
            min = middle
            max = middle
        }
    } else if (info == "WARMER") {
        if (current > prev) {
            int sum = prev + current
            int new_lower = (sum / 2) + 1
            if (new_lower > min)
                min = new_lower
        } else if (current < prev) {
            int sum = prev + current
            int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2)
            if (new_upper < max)
                max = new_upper
        }
    } else if (info == "COLDER") {
        if (current > prev) {
            int sum = prev + current
            int new_upper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2)
            if (new_upper < max)
                max = new_upper
        } else if (current < prev) {
            int sum = prev + current
            int new_lower = (sum / 2) + 1
            if (new_lower > min)
                min = new_lower
        }
    }
    return "${min} ${max}"
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
String narrow(int x0, int y0, int x, int y, int x_min, int x_max, int y_min, int y_max, String info) {
   
    if (x_min != x_max) {
        String new_x = narrow_dimension(x0, x, x_min, x_max, info)
        x_min = Integer.parseInt(new_x.split(" ")[0])
        x_max = Integer.parseInt(new_x.split(" ")[1])
    } else if (y_min != y_max) {
        String new_y = narrow_dimension(y0, y, y_min, y_max, info)
        y_min = Integer.parseInt(new_y.split(" ")[0])
        y_max = Integer.parseInt(new_y.split(" ")[1])
    }
    
    return "${x_min} ${y_min} ${x_max} ${y_max}"
}

// Main code
Scanner input = new Scanner(System.in)

int w = input.nextInt()
int h = input.nextInt()
int _ = input.nextInt()
int x0 = input.nextInt()
int y0 = input.nextInt()
int x = x0
int y = y0

int x_min = 0
int x_max = w - 1
int y_min = 0
int y_max = h - 1

while (true) {
    String info = input.next()

    String new_bounds = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info)
    String[] parts = new_bounds.split(" ")
    x_min = Integer.parseInt(parts[0])
    y_min = Integer.parseInt(parts[1])
    x_max = Integer.parseInt(parts[2])
    y_max = Integer.parseInt(parts[3])

   

    x0 = x
    y0 = y

    if (x_min != x_max) {
        if (x0 == 0 && x_max + x_min + 1 != w) {
            x = (3 * x_min + x_max) / 2 - x0
        } else if (x0 == w - 1 && x_max + x_min + 1 != w) {
            x = (x_min + 3 * x_max) / 2 - x0
        } else {
            x = x_min + x_max - x0
        }
        if (x == x0) {
            x = x0 + 1
        }
        x = Math.max(0, Math.min(w - 1, x))
    } else {
        if (x != x_min) {
            x = x_min
            x0 = x
            println "${x} ${y}"
            info = input.next()
        }
        if (y_min != y_max) {
            if (y0 == 0 && y_max + y_min + 1 != h) {
                y = (3 * y_min + y_max) / 2 - y0
            } else if (y0 == h - 1 && y_max + y_min + 1 != h) {
                y = (y_min + 3 * y_max) / 2 - y0
            } else {
                y = y_max + y_min - y0
            }
            if (y == y0) {
                y = y0 + 1
            }
            y = Math.max(0, Math.min(h - 1, y))
        } else {
            y = y_min
        }
    }

    println "${x} ${y}"
}
