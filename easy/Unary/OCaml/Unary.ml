(* Function to convert an integer to a 7-bit binary string *)
let to_binary n =
  let rec aux n acc =
    if n = 0 then acc
    else aux (n / 2) ((string_of_int (n mod 2)) ^ acc)
  in
  let binary = aux n "" in
  String.make (7 - String.length binary) '0' ^ binary (* Pad with leading zeros *)

let () =
  let msg = input_line stdin in

  let output = ref "" in
  let bn = ref "" in
  let b = ref '\000' in (* Track the previous bit *)

  (* Convert each character to its binary representation *)
  for i = 0 to String.length msg - 1 do
    let c = msg.[i] in
    (* Convert to ASCII *)
    let ascii = Char.code c in
    (* Convert to binary and pad to 7 bits *)
    let binary = to_binary ascii in
    bn := !bn ^ binary;
  done;

  (* Convert the binary string to unary *)
  for i = 0 to String.length !bn - 1 do
    let c = String.get !bn i in
    if c <> !b then begin
      if c = '0' then
        output := !output ^ " 00 "
      else
        output := !output ^ " 0 ";
      b := c;
    end;
    output := !output ^ "0";
  done;

  (* Trim the leading space *)
  let trimmed_output = String.trim !output in
  print_endline trimmed_output