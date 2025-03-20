(* The while loop represents the game. *)
(* Each iteration represents a turn of the game *)
(* where you are given inputs (the heights of the mountains) *)
(* and where you have to print an output (the index of the mountain to fire on) *)
(* The inputs you are given are automatically updated according to your last actions. *)


(* game loop *)
while true do
  let biggest = ref 0 in
  let num = ref 0 in
  
  for i = 0 to 7 do
      let mountainh = int_of_string (input_line stdin) in (* represents the height of one mountain. *)
      
      if !biggest < mountainh then begin
          biggest := mountainh;
          num := i;
      end;
      ();
  done;

  
  (* Write an action using print_endline *)
  (* To debug: prerr_endline "Debug message"; *)
  
  print_endline (string_of_int !num); (* The index of the mountain to fire on. *)
  ();
done;
