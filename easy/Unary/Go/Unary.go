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

	scanner.Scan()
	msg := scanner.Text()
	output := ""
	bn := ""
	b := '\x00'

	for _, c := range msg {
		// Convert the character to ascii
		ascii := int(c)
		// Convert the ascii to binary
		binary_value := fmt.Sprintf("%b", ascii)
		// Add leading zeros to make it 7 bits
		binary := ""
		for i := 0; i < 7-len(binary_value); i++ {
			binary += "0"
		}
		binary += binary_value

		// Add the binary value to the binary string
		bn += binary
	}

	// Loop through the binary string
	for _, c := range bn {
		if c != b {
			if c == '1' {
				output += " 0 "
			} else {
				output += " 00 "
			}
			b = c
		}
		output += "0"
	}

	// trim leading and trailing spaces
	output = strings.TrimSpace(output)

	fmt.Println(output)
}
