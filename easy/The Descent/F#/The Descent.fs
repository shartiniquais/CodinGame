(* The while loop represents the game. *)
(* Each iteration represents a turn of the game *)
(* where you are given inputs (the heights of the mountains) *)
(* and where you have to print an output (the index of the mountain to fire on) *)
(* The inputs you are given are automatically updated according to your last actions. *)
open System


(* game loop *)
while true do
    let mutable biggest = 0
    let mutable num = 0

    for i in 0 .. 7 do
        let mountainH = int(Console.In.ReadLine()) (* represents the height of one mountain. *)
        if biggest < mountainH then
            biggest <- mountainH
            num <- i
        ()

    
    (* Write an action using printfn *)
    (* To debug: eprintfn "Debug message" *)
    
    printfn "%d" num (* The index of the mountain to fire on. *)
    ()
