(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)
open System

let msg = Console.In.ReadLine()
let mutable output = ""
let mutable bn = ""
let mutable b = '\000'

for i = 0 to msg.Length - 1 do
    // convert the character to ascii
    let ascii = Convert.ToInt32(msg.[i])
    // convert the ascii to binary
    let binary_value = Convert.ToString(ascii, 2)
    // pad the binary value with 0s to make it 7 bits
    let binary = binary_value.PadLeft(7, '0')
    // append the binary value to the the binary string
    bn <- bn + binary

for i = 0 to bn.Length - 1 do
    // if the current bit is different from the previous bit
    if bn.[i] <> b then
        // if the previous bit is 1, append 0 to the output
        if bn.[i] = '1' then
            output <- output + " 0 "
        // if the previous bit is 0, append 00 to the output
        else
            output <- output + " 00 "
        b <- bn.[i]
    // append 0 to the output
    output <- output + "0"

// trim the output to remove leading and trailing spaces
output <- output.Trim()

Console.WriteLine(output)

