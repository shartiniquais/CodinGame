(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)
open System

(* W: width of the building. *)
(* H: height of the building. *)
let token = (Console.In.ReadLine()).Split [|' '|]
let w = int(token.[0])
let h = int(token.[1])
let _ = int(Console.In.ReadLine()) (* maximum number of turns before game over. (not used) *)
let token1 = (Console.In.ReadLine()).Split [|' '|]
let mutable x0 = int(token1.[0])
let mutable y0 = int(token1.[1])

let mutable left = 0
let mutable right = w - 1
let mutable up = 0
let mutable down = h - 1

(* game loop *)
while true do
    let bombDir = Console.In.ReadLine() (* the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL) *)
    
    if (bombDir.Contains("U")) then
        down <- y0 - 1
    elif (bombDir.Contains("D")) then
        up <- y0 + 1
    if (bombDir.Contains("L")) then
        right <- x0 - 1
    elif (bombDir.Contains("R")) then
        left <- x0 + 1

    x0 <- (left + right) / 2
    y0 <- (up + down) / 2

    printfn "%d %d" x0 y0
    ()
