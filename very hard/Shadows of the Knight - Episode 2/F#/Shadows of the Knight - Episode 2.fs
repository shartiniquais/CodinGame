open System

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Function narrow_dimension:                                                                                      //
//   Updates the search interval in one dimension                                                                  //
//   based on the feedback and the comparison between                                                              //
//   the previous position (x0 or y0) and the current position (x or y).                                           //
//                                                                                                                 //
// Parameters:                                                                                                     //
//   $1 : previous position on the axis (x0 or y0)                                                                 //
//   $2 : current position on the axis (x or y)                                                                    //
//   $3 : current lower bound (x_min or y_min)                                                                     //
//   $4 : current upper bound (x_max or y_max)                                                                     //
//   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         //
//                                                                                                                 //
// For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              //
// exactly in the middle.                                                                                          //
//                                                                                                                 //
// For WARMER/COLDER, we deduce which side of the interval to keep:                                                //
//   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               //
//     so new_min = ((x0+x)/2) + 1.                                                                                //
//   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    //
//                                                                                                                 //
// The same reasoning applies for y.                                                                               //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
let narrow_dimension prev current min max info =
    let mutable min = min
    let mutable max = max
    if info = "SAME" then
        let sum = prev + current
        if sum % 2 = 0 then
            let middle = sum / 2
            min <- middle
            max <- middle
    elif info = "WARMER" then
        let sum = prev + current
        if current > prev then
            let new_lower = (sum / 2) + 1
            if new_lower > min then
                min <- new_lower
        elif current < prev then
            let new_upper = if sum % 2 = 0 then (sum / 2 - 1) else (sum / 2)
            if new_upper < max then
                max <- new_upper
    elif info = "COLDER" then
        let sum = prev + current
        if current > prev then
            let new_upper = if sum % 2 = 0 then (sum / 2 - 1) else (sum / 2)
            if new_upper < max then
                max <- new_upper
        elif current < prev then
            let new_lower = (sum / 2) + 1
            if new_lower > min then
                min <- new_lower
    sprintf "%d %d" min max

////////////////////////////////////////////////////////////
// Function narrow:                                      //
// Applies narrow_dimension on x as long as              //
// the horizontal interval is not reduced to a single    //
// value, then on y if x is already determined.          //
////////////////////////////////////////////////////////////
let narrow x0 y0 x y x_min x_max y_min y_max info =
    eprintfn "narrow: x0: %d y0: %d x_min: %d x_max: %d y_min: %d y_max: %d info: %s" x0 y0 x_min x_max y_min y_max info
    let mutable x_min = x_min
    let mutable x_max = x_max
    let mutable y_min = y_min
    let mutable y_max = y_max
    if x_min <> x_max then
        let parts = narrow_dimension x0 x x_min x_max info |> fun s -> s.Split ' '
        x_min <- int parts.[0]
        x_max <- int parts.[1]
    elif y_min <> y_max then
        let parts = narrow_dimension y0 y y_min y_max info |> fun s -> s.Split ' '
        y_min <- int parts.[0]
        y_max <- int parts.[1]
    eprintfn "narrow : x_min: %d x_max: %d y_min: %d y_max: %d" x_min x_max y_min y_max
    sprintf "%d %d %d %d" x_min x_max y_min y_max

// Initial input
let inputs = Console.ReadLine().Split ' '
let w = int inputs.[0]
let h = int inputs.[1]
let _ = int (Console.ReadLine()) // number of turns (unused)
let inputs2 = Console.ReadLine().Split ' '
let mutable x0 = int inputs2.[0]
let mutable y0 = int inputs2.[1]
let mutable x = x0
let mutable y = y0
let mutable x_min = 0
let mutable x_max = w - 1
let mutable y_min = 0
let mutable y_max = h - 1

// Game loop
while true do
    let info = Console.ReadLine()
    let bounds = narrow x0 y0 x y x_min x_max y_min y_max info |> fun s -> s.Split ' '
    x_min <- int bounds.[0]
    x_max <- int bounds.[1]
    y_min <- int bounds.[2]
    y_max <- int bounds.[3]

    eprintfn "narrow results: x_min: %d x_max: %d y_min: %d y_max: %d" x_min x_max y_min y_max

    x0 <- x
    y0 <- y

    if x_min <> x_max then
        if x0 = 0 && x_max + x_min + 1 <> w then
            x <- (3 * x_min + x_max) / 2 - x0
        elif x0 = w - 1 && x_max + x_min + 1 <> w then
            x <- (x_min + 3 * x_max) / 2 - x0
        else
            x <- x_max + x_min - x0
        if x = x0 then x <- x0 + 1
        if x < 0 then x <- 0
        if x > w - 1 then x <- w - 1
    else
        if x <> x_min then
            x <- x_min
            x0 <- x
            printfn "%d %d" x y
            let _ = Console.ReadLine() in ()
        if y_min <> y_max then
            if y0 = 0 && y_max + y_min + 1 <> h then
                y <- (3 * y_min + y_max) / 2 - y0
            elif y0 = h - 1 && y_max + y_min + 1 <> h then
                y <- (y_min + 3 * y_max) / 2 - y0
            else
                y <- y_max + y_min - y0
            if y = y0 then y <- y + 1
            if y < 0 then y <- 0
            if y > h - 1 then y <- h - 1
        else
            y <- y_min

    printfn "%d %d" x y
