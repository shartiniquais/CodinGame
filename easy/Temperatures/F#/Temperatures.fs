(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)
open System

let n = int(Console.In.ReadLine()) (* the number of temperatures to analyse *)
if n <> 0 then
    // Read the temperatures into a list
    let values = 
        Console.ReadLine().Split(' ') 
        |> Array.map int

    // Initialize the minimum value and its absolute distance
    let mutable minValue = values.[0]
    let mutable minDistance = abs minValue

    // Iterate through the temperatures to find the closest to zero
    for i in 1 .. values.Length - 1 do
        let dist = abs values.[i]
        if dist < minDistance || (dist = minDistance && values.[i] > minValue) then
            minValue <- values.[i]
            minDistance <- dist

    // Print the closest temperature
    printfn "%d" minValue
else
    // Print 0 if there are no temperatures
    printfn "0"