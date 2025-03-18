import std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

void main()
{
    int n = readln.chomp.to!int; // the number of temperatures to analyse
    
    if (n == 0){
        writeln(0);
        return;
    }

    auto inputs = readln.split;
    int min_value = to!int(inputs[0]);
    int min_distance = abs(min_value);

    foreach (t; inputs) {
        int dist = abs(to!int(t));
        if (dist < min_distance || (dist == min_distance && to!int(t) > min_value)) {
            min_value = to!int(t);
            min_distance = dist;
        }
    }

    writeln(min_value);
}