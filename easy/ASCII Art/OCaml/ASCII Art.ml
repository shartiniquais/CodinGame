let l = int_of_string (input_line stdin) in
let h = int_of_string (input_line stdin) in
let t = String.uppercase_ascii (input_line stdin) in

let ascii_art = Array.init h (fun _ -> input_line stdin) in
let result = Array.init h (fun _ -> Buffer.create (l * 26)) in

String.iter (fun c ->
  let index =
    if c >= 'A' && c <= 'Z' then
      Char.code c - Char.code 'A'
    else
      26
  in
  for i = 0 to h - 1 do
    let line = ascii_art.(i) in
    let start = index * l in
    let chunk = String.sub line start l in
    Buffer.add_string result.(i) chunk
  done
) t;

Array.iter (fun buf -> print_endline (Buffer.contents buf)) result