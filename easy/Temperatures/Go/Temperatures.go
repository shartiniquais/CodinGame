package main

import "fmt"
import "math"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    var n int
    fmt.Scan(&n)

    if n != 0 {
        // Read the temperatures into a slice
        values := make([]int, n)
        for i := 0; i < n; i++ {
            fmt.Scan(&values[i])
        }

        // Initialize the minimum value and its absolute distance
        minValue := values[0]
        minDistance := int(math.Abs(float64(minValue)))

        // Iterate through the temperatures to find the closest to zero
        for i := 1; i < n; i++ {
            dist := int(math.Abs(float64(values[i])))
            if dist < minDistance || (dist == minDistance && values[i] > minValue) {
                minValue = values[i]
                minDistance = dist
            }
        }

        // Print the closest temperature
        fmt.Println(minValue)
    } else {
        // Print 0 if there are no temperatures
        fmt.Println(0)
    }
}