(* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////// *)
(* // Function narrow_dimension:                                                                                      *)
(* //   Updates the search interval in one dimension                                                                  *)
(* //   based on the feedback and the comparison between                                                              *)
(* //   the previous position (x0 or y0) and the current position (x or y).                                           *)
(* //                                                                                                                 *)
(* // Parameters:                                                                                                     *)
(* //   $1 : previous position on the axis (x0 or y0)                                                                 *)
(* //   $2 : current position on the axis (x or y)                                                                    *)
(* //   $3 : current lower bound (x_min or y_min)                                                                     *)
(* //   $4 : current upper bound (x_max or y_max)                                                                     *)
(* //   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         *)
(* //                                                                                                                 *)
(* // For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              *)
(* // exactly in the middle.                                                                                          *)
(* //                                                                                                                 *)
(* // For WARMER/COLDER, we deduce which side of the interval to keep:                                                *)
(* //   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               *)
(* //     so new_min = ((x0+x)/2) + 1.                                                                                *)
(* //   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    *)
(* //                                                                                                                 *)
(* // The same reasoning applies for y.                                                                               *)
(* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////// *)
let narrow_dimension prev current min_ max_ info =
  let sum = prev + current in
  match info with
  | "SAME" ->
      if sum mod 2 = 0 then
        let middle = sum / 2 in
        (middle, middle)
      else (min_, max_)
  | "WARMER" ->
      if current > prev then
        let new_lower = (sum / 2) + 1 in
        (max min_ new_lower, max_)
      else if current < prev then
        let new_upper = if sum mod 2 = 0 then (sum / 2) - 1 else sum / 2 in
        (min_, min max_ new_upper)
      else (min_, max_)
  | "COLDER" ->
      if current > prev then
        let new_upper = if sum mod 2 = 0 then (sum / 2) - 1 else sum / 2 in
        (min_, min max_ new_upper)
      else if current < prev then
        let new_lower = (sum / 2) + 1 in
        (max min_ new_lower, max_)
      else (min_, max_)
  | _ -> (min_, max_)

(* //////////////////////////////////////////////////////////////// *)
(* // Function narrow:                                           // *)
(* // Applies narrow_dimension on x as long as                   // *)
(* // the horizontal interval is not reduced to a single value,  // *)
(* // then on y if x is already determined.                      // *)
(* //////////////////////////////////////////////////////////////// *)
let narrow x0 y0 x y x_min x_max y_min y_max info =
  prerr_endline (Printf.sprintf "narrow: x0: %d y0: %d x_min: %d x_max: %d y_min: %d y_max: %d info: %s" x0 y0 x_min x_max y_min y_max info);
  let x_min, x_max, y_min, y_max =
    if x_min <> x_max then
      let x_min', x_max' = narrow_dimension x0 x x_min x_max info in
      (x_min', x_max', y_min, y_max)
    else if y_min <> y_max then
      let y_min', y_max' = narrow_dimension y0 y y_min y_max info in
      (x_min, x_max, y_min', y_max')
    else (x_min, x_max, y_min, y_max)
  in
  prerr_endline (Printf.sprintf "narrow : x_min: %d x_max: %d y_min: %d y_max: %d" x_min x_max y_min y_max);
  (x_min, x_max, y_min, y_max)

let () =
  let w, h = Scanf.sscanf (input_line stdin) " %d %d" (fun w h -> w, h) in
  let _ = int_of_string (input_line stdin) in
  let x0_init, y0_init = Scanf.sscanf (input_line stdin) " %d %d" (fun x y -> x, y) in

  let rec loop x0 y0 x y x_min x_max y_min y_max =
    let info = input_line stdin in
    let x_min, x_max, y_min, y_max = narrow x0 y0 x y x_min x_max y_min y_max info in

    let x0, y0 = x, y in
    let x =
      if x_min <> x_max then
        let x =
          if x0 = 0 && x_max + x_min + 1 <> w then
            (3 * x_min + x_max) / 2 - x0
          else if x0 = w - 1 && x_max + x_min + 1 <> w then
            (x_min + 3 * x_max) / 2 - x0
          else
            x_max + x_min - x0
        in
        let x = if x = x0 then x0 + 1 else x in
        let x = max 0 (min (w - 1) x) in
        x
      else
        if x <> x_min then begin
          let x = x_min in
          let x0 = x in
          Printf.printf "%d %d\n%!" x y;
          let _ = input_line stdin in
          x
        end else x
    in

    let y =
      if x_min = x_max then
        if y_min <> y_max then
          let y =
            if y0 = 0 && y_max + y_min + 1 <> h then
              (3 * y_min + y_max) / 2 - y0
            else if y0 = h - 1 && y_max + y_min + 1 <> h then
              (y_min + 3 * y_max) / 2 - y0
            else
              y_max + y_min - y0
          in
          let y = if y = y0 then y + 1 else y in
          let y = max 0 (min (h - 1) y) in
          y
        else y_min
      else y
    in

    Printf.printf "%d %d\n%!" x y;
    loop x0 y0 x y x_min x_max y_min y_max
  in

  let x = x0_init in
  let y = y0_init in
  let x_min = 0 and x_max = w - 1 in
  let y_min = 0 and y_max = h - 1 in
  loop x0_init y0_init x y x_min x_max y_min y_max
