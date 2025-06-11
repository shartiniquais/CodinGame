import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

let l = Int(readLine()!)!
let h = Int(readLine()!)!
let t = readLine()!.uppercased()

let asciiArt = (0..<h).map { _ in readLine()! }

var result = Array(repeating: "", count: h)

for c in t {
    let index: Int
    if c >= "A" && c <= "Z" {
        index = Int(c.asciiValue! - Character("A").asciiValue!)
    } else {
        index = 26
    }

    for i in 0..<h {
        let line = asciiArt[i]
        let startIdx = line.index(line.startIndex, offsetBy: index * l)
        let endIdx = line.index(startIdx, offsetBy: l)
        let fragment = line[startIdx..<endIdx]
        result[i] += fragment
    }
}

for line in result {
    print(line)
}

