import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

let MSG = readLine()!
var output = ""
var bn = ""
var b: Character = "\0" // Initialize as a null character

// Helper function to get a character at a specific index in a string
func charAt(_ str: String, _ index: Int) -> Character {
    return str[str.index(str.startIndex, offsetBy: index)]
}

// Convert each character in the message to its binary representation
for i in 0..<MSG.count {
    let c = charAt(MSG, i)
    // Convert to ASCII
    let ascii = Int(c.asciiValue!)
    // Convert to binary
    let binary = String(ascii, radix: 2)
    // Add leading zeros to make it 7 bits
    let binary2 = String(repeating: "0", count: 7 - binary.count) + binary
    // Append the binary value to the binary string
    bn += binary2
}

// Convert the binary string to unary
for i in 0..<bn.count {
    let c = charAt(bn, i)
    if c != b {
        if c == "0" {
            output += " 00 "
        } else {
            output += " 0 "
        }
        b = c
    }
    output += "0"
}

// Trim leading and trailing spaces and print the result
print(output.trimmingCharacters(in: .whitespacesAndNewlines))