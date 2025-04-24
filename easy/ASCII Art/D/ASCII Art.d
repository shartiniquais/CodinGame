import std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

void main()
{
    int l = readln.chomp.to!int;
    int h = readln.chomp.to!int;
    string t = readln.chomp.toUpper;
    string[] asciiArt = [];
    for (int i = 0; i < h; i++) {
        string row = readln.chomp;
        asciiArt ~= row;
    }

    string[] result = [];

    for (int i = 0; i < t.length; i++) {
        char c = t[i];
        int index;
        if ('A' <= c && c <= 'Z') {
            index = c - 'A';
        } else {
            index = 26;
        }

        for (int j = 0; j < h; j++) {
            if (result.length <= j) {
                result ~= "";
            }
            result[j] ~= asciiArt[j][index * l .. (index + 1) * l];
        }
    }

    foreach (string line; result) {
        writeln(line);
    }
}