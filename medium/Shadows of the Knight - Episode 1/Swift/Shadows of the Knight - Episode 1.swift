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

let inputs = (readLine()!).split(separator: " ").map(String.init)
let w = Int(inputs[0])! // width of the building.
let h = Int(inputs[1])! // height of the building.
let _ = Int(readLine()!)! // maximum number of turns before game over. (not used)
let inputs2 = (readLine()!).split(separator: " ").map(String.init)
var x0 = Int(inputs2[0])!
var y0 = Int(inputs2[1])!

var left = 0
var right = w - 1
var top = 0
var bottom = h - 1

// game loop
while true {
    let bombDir = readLine()! // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if bombDir.contains("U") {
        bottom = y0 - 1
    } else if bombDir.contains("D") {
        top = y0 + 1
    }
    if bombDir.contains("L") {
        right = x0 - 1
    } else if bombDir.contains("R") {
        left = x0 + 1
    }

    x0 = (left + right) / 2
    y0 = (top + bottom) / 2

    print(x0, y0)
}
