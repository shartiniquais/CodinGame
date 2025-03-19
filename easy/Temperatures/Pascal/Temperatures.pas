// Auto-generated code below aims at helping you parse
// the standard input according to the problem statement.
program Answer;
{$H+}
uses sysutils, classes, math;

// Helper to read a line and split tokens
procedure ParseIn(Inputs: TStrings);
var Line: string;
begin
    readln(Line);
    Inputs.Clear;
    Inputs.Delimiter := ' ';
    Inputs.DelimitedText := Line;
end;

var
    n: Int32; // the number of temperatures to analyse
    t: Int32; // a temperature expressed as an integer ranging from -273 to 5526
    i: Int32;
    Inputs: TStringList;
    values: array of Int32;
    min_value: Int32;
    min_distance: Int32;
begin
    Inputs := TStringList.Create;
    ParseIn(Inputs);
    n := StrToInt(Inputs[0]);
    ParseIn(Inputs);

    if n = 0 then
    begin
        writeln('0');
        flush(StdErr); flush(output);
        exit;
    end;

    // Initialize the values array
    SetLength(values, n);
    for i := 0 to n - 1 do
    begin
        t := StrToInt(Inputs[i]);
        values[i] := t;
    end;

    min_value := 5526;
    min_distance := 5526;

    for i := 0 to High(values) do
    begin
        if (Abs(values[i]) < min_distance) or ((Abs(values[i]) = min_distance) and (values[i] > min_value)) then
        begin
            min_distance := Abs(values[i]);
            min_value := values[i];
        end;
    end;

    // Write an answer using writeln()
    // To debug: writeln(StdErr, 'Debug messages...');

    writeln(min_value);
    flush(StdErr); flush(output); // DO NOT REMOVE
end.