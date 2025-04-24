package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Buffer(make([]byte, 1000000), 1000000)

    var l int
    scanner.Scan()
    fmt.Sscan(scanner.Text(), &l)

    var h int
    scanner.Scan()
    fmt.Sscan(scanner.Text(), &h)

    scanner.Scan()
    t := strings.ToUpper(scanner.Text())

    asciiArt := make([]string, h)
    for i := 0; i < h; i++ {
        scanner.Scan()
        asciiArt[i] = scanner.Text()
    }

    result := make([]string, h)

    for _, char := range t {
        var index int
        if char >= 'A' && char <= 'Z' {
            index = int(char - 'A')
        } else {
            index = 26
        }

        for i := 0; i < h; i++ {
            row := asciiArt[i]
            start := index * l
            end := start + l
            if end > len(row) {
                end = len(row)
            }
            result[i] += row[start:end]
        }
    }

    for _, line := range result {
        fmt.Println(line)
    }
}
