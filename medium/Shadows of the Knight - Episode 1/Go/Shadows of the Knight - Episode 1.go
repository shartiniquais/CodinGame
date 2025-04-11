package main

import "fmt"
import "strings"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    // W: width of the building.
    // h: height of the building.
    var w, h int
    fmt.Scan(&w, &h)
    
    // N : maximum number of turns before game over. (not used)
    var N int
    fmt.Scan(&N)
    
    var x0, y0 int
    fmt.Scan(&x0, &y0)

	var left, right, top, bottom int
	left = 0
	right = w - 1
	top = 0
	bottom = h - 1

    
    for {
        // bombDir: the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
        var bombDir string
        fmt.Scan(&bombDir)
        
        if (strings.Contains(bombDir, "U")) {
			bottom = y0 - 1
		} else if (strings.Contains(bombDir, "D")) {
			top = y0 + 1
		}
		if (strings.Contains(bombDir, "L")) {
			right = x0 - 1
		} else if (strings.Contains(bombDir, "R")) {
			left = x0 + 1
		}

		x0 = (left + right) / 2
		y0 = (top + bottom) / 2
		fmt.Println(x0, y0)
    }
}