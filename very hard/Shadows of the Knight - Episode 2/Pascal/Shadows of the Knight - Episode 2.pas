// Auto-generated code below aims at helping you parse
// the standard input according to the problem statement.
program Answer;
{$H+}
uses sysutils, classes, math;

// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// // Function narrow_dimension:                                                                                      //
// //   Updates the search interval in one dimension                                                                  //
// //   based on the feedback and the comparison between                                                              //
// //   the previous position (x0 or y0) and the current position (x or y).                                           //
// //                                                                                                                 //
// // Parameters:                                                                                                     //
// //   $1 : previous position on the axis (x0 or y0)                                                                 //
// //   $2 : current position on the axis (x or y)                                                                    //
// //   $3 : current lower bound (x_min or y_min)                                                                     //
// //   $4 : current upper bound (x_max or y_max)                                                                     //
// //   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         //
// //                                                                                                                 //
// // For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              //
// // exactly in the middle.                                                                                          //
// //                                                                                                                 //
// // For WARMER/COLDER, we deduce which side of the interval to keep:                                                //
// //   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               //
// //     so new_min = ((x0+x)/2) + 1.                                                                                //
// //   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    //
// //                                                                                                                 //
// // The same reasoning applies for y.                                                                               //
// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure NarrowDimension(prev, current: Integer; var min_, max_: Integer; info: String);
var
    sum, middle, new_lower, new_upper: Integer;
begin
    sum := prev + current;
    if info = 'SAME' then
    begin
        if sum mod 2 = 0 then
        begin
            middle := sum div 2;
            min_ := middle;
            max_ := middle;
        end;
    end
    else if info = 'WARMER' then
    begin
        if current > prev then
        begin
            new_lower := (sum div 2) + 1;
            if new_lower > min_ then min_ := new_lower;
        end
        else if current < prev then
        begin
            if sum mod 2 = 0 then
                new_upper := (sum div 2) - 1
            else
                new_upper := sum div 2;
            if new_upper < max_ then max_ := new_upper;
        end;
    end
    else if info = 'COLDER' then
    begin
        if current > prev then
        begin
            if sum mod 2 = 0 then
                new_upper := (sum div 2) - 1
            else
                new_upper := sum div 2;
            if new_upper < max_ then max_ := new_upper;
        end
        else if current < prev then
        begin
            new_lower := (sum div 2) + 1;
            if new_lower > min_ then min_ := new_lower;
        end;
    end;
end;

// ////////////////////////////////////////////////////////////////
// // Function narrow:                                           //
// // Applies narrow_dimension on x as long as                   //
// // the horizontal interval is not reduced to a single value,  //
// // then on y if x is already determined.                      //
// ////////////////////////////////////////////////////////////////
procedure Narrow(x0, y0, x, y: Integer;
    var x_min, y_min, x_max, y_max: Integer;
    info: String);
begin
    writeln(StdErr, Format('narrow: x0=%d, y0=%d, x=%d, y=%d, x_min=%d, y_min=%d, x_max=%d, y_max=%d, info=%s',
        [x0, y0, x, y, x_min, y_min, x_max, y_max, info]));
    if x_min <> x_max then
        NarrowDimension(x0, x, x_min, x_max, info)
    else if y_min <> y_max then
        NarrowDimension(y0, y, y_min, y_max, info);
    writeln(StdErr, Format('narrow: x_min=%d, y_min=%d, x_max=%d, y_max=%d', [x_min, y_min, x_max, y_max]));
end;

procedure ParseIn(Inputs: TStrings);
var Line: string;
begin
    readln(Line);
    Inputs.Clear;
    Inputs.Delimiter := ' ';
    Inputs.DelimitedText := Line;
end;

var
    W, H, N: Integer;
    X0, Y0, X, Y: Integer;
    x_min, y_min, x_max, y_max: Integer;
    bombDir: String;
    Inputs: TStringList;
begin
    Inputs := TStringList.Create;
    ParseIn(Inputs); W := StrToInt(Inputs[0]); H := StrToInt(Inputs[1]);
    ParseIn(Inputs); N := StrToInt(Inputs[0]);
    ParseIn(Inputs); X0 := StrToInt(Inputs[0]); Y0 := StrToInt(Inputs[1]);
    X := X0; Y := Y0;
    x_min := 0; y_min := 0;
    x_max := W - 1; y_max := H - 1;

    while true do
    begin
        ParseIn(Inputs);
        bombDir := Inputs[0];

        Narrow(X0, Y0, X, Y, x_min, y_min, x_max, y_max, bombDir);

        X0 := X; Y0 := Y;

        if x_min <> x_max then
        begin
            if (X0 = 0) and (x_max + x_min + 1 <> W) then
                X := (3 * x_min + x_max) div 2 - X0
            else if (X0 = W - 1) and (x_max + x_min + 1 <> W) then
                X := (x_min + 3 * x_max) div 2 - X0
            else
                X := x_max + x_min - X0;

            if X = X0 then X := X0 + 1;
            if X < 0 then X := 0;
            if X > W - 1 then X := W - 1;
        end
        else
        begin
            if X <> x_min then
            begin
                X := x_min;
                X0 := X;
                writeln(X, ' ', Y); flush(output); ParseIn(Inputs); bombDir := Inputs[0];
            end;

            if y_min <> y_max then
            begin
                if (Y0 = 0) and (y_max + y_min + 1 <> H) then
                    Y := (3 * y_min + y_max) div 2 - Y0
                else if (Y0 = H - 1) and (y_max + y_min + 1 <> H) then
                    Y := (y_min + 3 * y_max) div 2 - Y0
                else
                    Y := y_max + y_min - Y0;

                if Y = Y0 then Y := Y + 1;
                if Y < 0 then Y := 0;
                if Y > H - 1 then Y := H - 1;
            end
            else Y := y_min;
        end;

        writeln(X, ' ', Y); flush(StdErr); flush(output);
    end;
end.
