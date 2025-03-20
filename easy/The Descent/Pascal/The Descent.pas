// The while loop represents the game.
// Each iteration represents a turn of the game
// where you are given inputs (the heights of the mountains)
// and where you have to print an output (the index of the mountain to fire on)
// The inputs you are given are automatically updated according to your last actions.
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
    mountainH : Int32; // represents the height of one mountain.
    i : Int32;
    Inputs: TStringList;
    biggest: Integer;
    num: Integer;
begin
    Inputs := TStringList.Create;

    // game loop
    while true do
    begin
        biggest := 0;
        num := 0;

        for i := 0 to 7 do
        begin
            ParseIn(Inputs);
            mountainH := StrToInt(Inputs[0]);

            if biggest < mountainH then
            begin
                biggest := mountainH;
                num := i;
            end;
        end;

        // Write an action using writeln()
        // To debug: writeln(StdErr, 'Debug messages...');

        writeln(num); // The index of the mountain to fire on.
        flush(StdErr); flush(output); // DO NOT REMOVE
    end;
end.