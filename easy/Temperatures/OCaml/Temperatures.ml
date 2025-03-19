(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)

let n = int_of_string (input_line stdin) in (* the number of temperatures to analyse *)

if n = 0 then
    print_endline "0"
else

  let values = ref [] in

  let inputs = String.split_on_char ' ' (input_line stdin) in
  for i = 0 to n - 1 do
      let t = int_of_string (List.nth inputs i) in (* a temperature expressed as an integer ranging from -273 to 5526 *)
      ();
      values := t :: !values
  done;

  let min_value = ref 5526 in
  let min_abs = ref 5526 in

  List.iter (fun x ->
    let abs = abs x in
    if abs < !min_abs || (abs = !min_abs && x > 0) then
      begin
        min_abs := abs;
        min_value := x
      end
  ) !values;


  (* Write an answer using print_endline *)
  (* To debug: prerr_endline "Debug message"; *)

  print_int !min_value;