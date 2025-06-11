program Answer;
{$H+}
uses SysUtils, Classes, Math;

var
    L: Int32;
    H: Int32;
    T: String;
    asciiArt: array of String;
    result: array of String;
    i: Int32;
    j: Int32;
    index: Int32;
    startIdx: Int32;
    endIdx: Int32;
    c: Char;
    substr: String;
    finalResult: String;
begin
    readln(L);
    readln(H);
    readln(T);
    T := UpperCase(T);

    SetLength(asciiArt, H);
    for i := 0 to H - 1 do
    begin
        readln(asciiArt[i]);
    end;

    SetLength(result, H);
    for i := 0 to H - 1 do
        result[i] := '';

// Pascal strings use 1-based indexing, so the loop starts at 1.
for j := 1 to Length(T) do
begin
    c := T[j];
    if (c >= 'A') and (c <= 'Z') then
        index := Ord(c) - Ord('A')
    else
        index := 26;

    for i := 0 to H - 1 do
    begin
        // startIdx assumes 1-based indexing for Copy function in Pascal
        startIdx := index * L + 1;
        endIdx := startIdx + L - 1;
        substr := Copy(asciiArt[i], startIdx, L);
        result[i] := result[i] + substr;
    end;
end;

    finalResult := '';
    for i := 0 to H - 1 do
        finalResult := finalResult + result[i] + sLineBreak;
    writeln(finalResult);

flush(StdErr); flush(output); // DO NOT REMOVE
end.
