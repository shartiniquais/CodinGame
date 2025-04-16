// Auto-generated code below aims at helping you parse
// the standard input according to the problem statement.
program Answer;
{$H+}
uses sysutils, classes, math;

// Helper to read a line and split tokens
procedure ParseIn(Inputs: TStrings) ;
var Line : string;
begin
    readln(Line);
    Inputs.Clear;
    Inputs.Delimiter := ' ';
    Inputs.DelimitedText := Line;
end;

var
    w : Int32; // width of the building.
    h : Int32; // height of the building.
    _ : Int32; // maximum number of turns before game over. (not used)
    x0 : Int32;
    y0 : Int32;
    bombDir : String; // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    Inputs: TStringList;
    left, right, up, down: Int32; // the bounds of the search area
begin
    Inputs := TStringList.Create;
    ParseIn(Inputs);
    w := StrToInt(Inputs[0]);
    h := StrToInt(Inputs[1]);
    ParseIn(Inputs);
    _ := StrToInt(Inputs[0]);
    ParseIn(Inputs);
    x0 := StrToInt(Inputs[0]);
    y0 := StrToInt(Inputs[1]);

    left := 0;
    right := w - 1;
    up := 0;
    down := h - 1;

    // game loop
    while true do
    begin
        ParseIn(Inputs);
        bombDir := Inputs[0];

        if (bombDir.Contains('U')) then
            down := y0 - 1;
        if (bombDir.Contains('D')) then
            up := y0 + 1;
        if (bombDir.Contains('L')) then
            right := x0 - 1;
        if (bombDir.Contains('R')) then
            left := x0 + 1;

        x0 := (left + right) div 2;
        y0 := (up + down) div 2;

        // the location of the next window Batman should jump to.
        writeln(x0, ' ', y0);
        flush(StdErr); flush(output); // DO NOT REMOVE
    end;
end.