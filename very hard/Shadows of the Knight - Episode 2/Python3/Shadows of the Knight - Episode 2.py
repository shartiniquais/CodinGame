import sys

# Read building dimensions: width and height.
w, h = [int(i) for i in input().split()]
input()  # Number of jumps (not used in this solution)
x0, y0 = [int(i) for i in input().split()]  # Starting position

# x0, y0: previous position; x, y: current position.
x, y = x0, y0

# xs and ys represent the remaining possible windows where the bomb could be.
# Initially, all columns (xs) and all rows (ys) are possible.
xs, ys = range(w), range(h)

def narrow(x0, y0, x, y, xs, ys, info):
    """
    Narrow down the possible bomb location based on sensor feedback.
    
    Parameters:
        x0, y0 (int): Previous position.
        x, y (int): Current position.
        xs (range): Possible columns.
        ys (range): Possible rows.
        info (str): Sensor feedback ("WARMER", "COLDER", "SAME", "UNKNOWN").
    """
    print("narrow: x0={}, y0={}, x={}, y={}, info={}".format(x0, y0, x, y, info), file=sys.stderr)
    
    # Binary search on the x-axis (columns)
    if len(xs) != 1:
        if info == "UNKNOWN":  # First jump: no info available.
            pass
        elif info == "SAME":  # Distance remains the same: keep only equidistant positions.
            xs = [i for i in xs if abs(x0 - i) == abs(x - i)]
        elif info == "WARMER":  # Getting closer: keep positions that are closer.
            xs = [i for i in xs if abs(x0 - i) > abs(x - i)]
        else:  # COLDER: getting further: keep positions that are farther.
            xs = [i for i in xs if abs(x0 - i) < abs(x - i)]
    
    # Binary search on the y-axis (rows) when x-axis is narrowed to one value.
    else:
        if info == "UNKNOWN":
            pass
        elif info == "SAME":
            ys = [i for i in ys if abs(y0 - i) == abs(y - i)]
        elif info == "WARMER":
            ys = [i for i in ys if abs(y0 - i) > abs(y - i)]
        else:
            ys = [i for i in ys if abs(y0 - i) < abs(y - i)]
    
    print(xs, file=sys.stderr)  # Debug: show remaining columns.
    print(ys, file=sys.stderr)  # Debug: show remaining rows.
    return xs, ys

# Main game loop
while True:
    info = input()  # Sensor feedback: "WARMER", "COLDER", "SAME", or "UNKNOWN"
    
    # Narrow down the search area based on sensor feedback.
    xs, ys = narrow(x0, y0, x, y, xs, ys, info)
    
    # Update previous position.
    x0, y0 = x, y
    
    # Binary search on the x-axis (columns)
    if len(xs) != 1:
        # Bisection between x0 and x to cut the zone roughly in half.
        if x0 == 0 and len(xs) != w:
            x = (3 * xs[0] + xs[-1]) // 2 - x0
        elif x0 == w - 1 and len(xs) != w:
            x = (xs[0] + 3 * xs[-1]) // 2 - x0
        else:
            x = xs[0] + xs[-1] - x0
        
        # Avoid staying in the same position.
        if x == x0:
            x += 1
        x = min(max(x, 0), w - 1)
    
    # Transition to binary search on the y-axis.
    else:
        if x != xs[0]:
            x = x0 = xs[0]
            print(x, y)
            info = input()
        # Finalize: if only one row remains.
        if len(ys) == 1:
            y = ys[0]
        else:
            if y0 == 0 and len(ys) != h:
                y = (3 * ys[0] + ys[-1]) // 2 - y0
            elif y0 == h - 1 and len(ys) != h:
                y = (ys[0] + 3 * ys[-1]) // 2 - y0
            else:
                y = ys[0] + ys[-1] - y0
            y = min(max(y, 0), h - 1)
    
    # Output the new position.
    print(x, y)
