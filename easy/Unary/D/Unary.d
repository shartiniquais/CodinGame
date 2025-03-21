import std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

void main()
{
    string msg = readln.chomp;
    string output = "";
    string bn = "";
    char b = '\0';

    foreach (char c; msg)
    {
        // convert char to ascii
        int ascii = c.to!int;
        // convert ascii to binary
        string binary_value = ascii.to!string(2);
        // pad with 0s
        while (binary_value.length < 7)
        {
            binary_value = "0" ~ binary_value;
        }    

        // append to bn
        bn ~= binary_value;
    }
    
    foreach (char c; bn)
    {
        if (c != b)
        {
            if (c == '1')
            {
                output ~= " 0 ";
            }
            else
            {
                output ~= " 00 ";
            }
            b = c; // Update previous bit
        }
        output ~= "0";
    }

    // Trim leading space
    output = output[1..$];

    writeln(output);
}