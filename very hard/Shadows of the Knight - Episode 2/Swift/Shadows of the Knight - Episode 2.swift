import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) {
        fputs(string, stderr)
    }
}
public var errStream = StderrOutputStream()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Function narrow_dimension:                                                                                      //
//   Updates the search interval in one dimension                                                                  //
//   based on the feedback and the comparison between                                                              //
//   the previous position (x0 or y0) and the current position (x or y).                                           //
//                                                                                                                 //
// For SAME, if (x0+x) (or y0+y) is even, the bomb is exactly in the middle.                                       //
// For WARMER/COLDER, we deduce which side of the interval to keep.                                                //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func narrowDimension(prev: Int, current: Int, min: Int, max: Int, info: String) -> (Int, Int) {
    let sum = prev + current
    var min = min
    var max = max

    switch info {
    case "SAME":
        if sum % 2 == 0 {
            let middle = sum / 2
            min = middle
            max = middle
        }
    case "WARMER":
        if current > prev {
            let newLower = (sum / 2) + 1
            if newLower > min {
                min = newLower
            }
        } else if current < prev {
            let newUpper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2)
            if newUpper < max {
                max = newUpper
            }
        }
    case "COLDER":
        if current > prev {
            let newUpper = (sum % 2 == 0) ? (sum / 2 - 1) : (sum / 2)
            if newUpper < max {
                max = newUpper
            }
        } else if current < prev {
            let newLower = (sum / 2) + 1
            if newLower > min {
                min = newLower
            }
        }
    default:
        break
    }

    return (min, max)
}

////////////////////////////////////////////////////////////////
// Function narrow:                                           //
// Applies narrow_dimension on x as long as                   //
// the horizontal interval is not reduced to a single value,  //
// then on y if x is already determined.                      //
////////////////////////////////////////////////////////////////
func narrow(x0: Int, y0: Int, x: Int, y: Int,
            xMin: Int, xMax: Int, yMin: Int, yMax: Int,
            info: String) -> (Int, Int, Int, Int) {
    print("narrow: x0: \(x0) y0: \(y0) x_min: \(xMin) x_max: \(xMax) y_min: \(yMin) y_max: \(yMax) info: \(info)", to: &errStream)

    var (xMin, xMax, yMin, yMax) = (xMin, xMax, yMin, yMax)

    if xMin != xMax {
        (xMin, xMax) = narrowDimension(prev: x0, current: x, min: xMin, max: xMax, info: info)
    } else if yMin != yMax {
        (yMin, yMax) = narrowDimension(prev: y0, current: y, min: yMin, max: yMax, info: info)
    }

    print("narrow : x_min: \(xMin) x_max: \(xMax) y_min: \(yMin) y_max: \(yMax)", to: &errStream)
    return (xMin, xMax, yMin, yMax)
}

let firstInput = readLine()!.split(separator: " ").map { Int($0)! }
let W = firstInput[0]
let H = firstInput[1]
let _ = Int(readLine()!)! // max turns, unused
let position = readLine()!.split(separator: " ").map { Int($0)! }
var x0 = position[0]
var y0 = position[1]
var x = x0
var y = y0

var xMin = 0, xMax = W - 1
var yMin = 0, yMax = H - 1

while true {
    var info = readLine()!

    (xMin, xMax, yMin, yMax) = narrow(x0: x0, y0: y0, x: x, y: y,
                                    xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, info: info)

    print("narrow results: x_min: \(xMin) x_max: \(xMax) y_min: \(yMin) y_max: \(yMax)", to: &errStream)

    x0 = x
    y0 = y

    if xMin != xMax {
        if x0 == 0 && xMax + xMin + 1 != W {
            x = (3 * xMin + xMax) / 2 - x0
        } else if x0 == W - 1 && xMax + xMin + 1 != W {
            x = (xMin + 3 * xMax) / 2 - x0
        } else {
            x = xMax + xMin - x0
        }

        if x == x0 {
            x += 1
        }
        x = max(0, min(W - 1, x))
    } else {
        if x != xMin {
            x = xMin
            x0 = x
            print("\(x) \(y)")
            info = readLine()!
        }

        if yMin != yMax {
            if y0 == 0 && yMax + yMin + 1 != H {
                y = (3 * yMin + yMax) / 2 - y0
            } else if y0 == H - 1 && yMax + yMin + 1 != H {
                y = (yMin + 3 * yMax) / 2 - y0
            } else {
                y = yMax + yMin - y0
            }

            if y == y0 {
                y += 1
            }
            y = max(0, min(H - 1, y))
        } else {
            y = yMin
        }
    }

    print("\(x) \(y)")
}
