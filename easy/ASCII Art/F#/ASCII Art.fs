(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)
open System

let l = int(Console.ReadLine())
let h = int(Console.ReadLine())
let t = Console.ReadLine().ToUpper()

let asciiArt = 
    [for _ in 1 .. h -> Console.ReadLine()]

let result = Array.create h ""

for ch in t do
    let index = 
        if ch >= 'A' && ch <= 'Z' then
            int ch - int 'A'
        else
            26

    for i in 0 .. h - 1 do
        let row = asciiArt.[i]
        let slice = row.Substring(index * l, l)
        result.[i] <- result.[i] + slice

for line in result do
    printfn "%s" line
