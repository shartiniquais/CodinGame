(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)

(* w: width of the building. *)
(* h: height of the building. *)
let w, h = Scanf.sscanf (input_line stdin) " %d  %d" (fun w h -> (w, h)) in
let n = int_of_string (input_line stdin) in (* maximum number of turns before game over. *)
let x0, y0 = Scanf.sscanf (input_line stdin) " %d  %d" (fun x0 y0 -> (x0, y0)) in
let x0 = ref x0 in
let y0 = ref y0 in

let left = ref 0 in
let right = ref (w - 1) in
let top = ref 0 in
let bottom = ref (h - 1) in

(* game loop *)
while true do
    let bombdir = input_line stdin in (* the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL) *)
    
    if String.contains bombdir 'U' then
        bottom := !y0 - 1
    else if String.contains bombdir 'D' then
        top := !y0 + 1;
    if String.contains bombdir 'L' then
        right := !x0 - 1
    else if String.contains bombdir 'R' then
        left := !x0 + 1;

    x0 := (!left + !right) / 2;
    y0 := (!top + !bottom) / 2;
    
    (* the location of the next window Batman should jump to. *)
    print_endline (string_of_int !x0 ^ " " ^ string_of_int !y0);
    ();
done;
