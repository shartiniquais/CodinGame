program Answer;
{$H+}
uses sysutils;

var
    MESSAGE: String;
    output: String;
    bn: String;
    b: Char;
    i, ascii: Integer;
    binary_value, binary: String;

// Function to convert an integer to a 7-bit binary string
function ToBinary(n: Integer): String;
var
    binary: String;
begin
    binary := '';
    while n > 0 do
    begin
        binary := IntToStr(n mod 2) + binary;
        n := n div 2;
    end;
    ToBinary := StringOfChar('0', 7 - Length(binary)) + binary; // Pad with leading zeros
end;

begin
    readln(MESSAGE);
    output := '';
    bn := '';
    b := #0; // Initialize the previous bit to null character

    // Convert each character to its binary representation
    for i := 1 to Length(MESSAGE) do
    begin
        ascii := Ord(MESSAGE[i]); // Convert character to ASCII
        binary_value := ToBinary(ascii); // Convert ASCII to binary
        bn := bn + binary_value; // Append the binary value to the binary string
    end;

    // Convert the binary string to unary
    for i := 1 to Length(bn) do
    begin
        if bn[i] <> b then
        begin
            if bn[i] = '1' then
                output := output + ' 0 '
            else
                output := output + ' 00 ';
            b := bn[i]; // Update the previous bit
        end;
        output := output + '0'; // Add a unary '0' for each bit
    end;

    // Trim leading spaces and print the result
    writeln(Trim(output));
end.