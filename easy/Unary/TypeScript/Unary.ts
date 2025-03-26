/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const MSG: string = readline();

let output: string = ""
let bn: string = ""
let b: string = ""

MSG.split("").forEach((c: string) => {
    // convert to ascii
    let ascii: number = c.charCodeAt(0)
    // convert to binary
    let binary = ascii.toString(2)
    // add leading 0s
    let binary2 = binary.padStart(7, "0")
    // add binary to bn
    bn += binary2
})

bn.split("").forEach((c: string) => {
    if (c != b){
        if (c == "0"){
            output += " 00 "
        } else {
            output += " 0 "
        }
        b = c
    }
    output += "0"
})

console.log(output.trim())
