input = new Scanner(System.in);

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

n = input.nextInt() // the number of temperatures to analyse
if (n == 0) {
    println "0"
    return
}

// array to store all temperatures
values = new int[n]
for (i = 0; i < n; ++i) {
    t = input.nextInt() // a temperature expressed as an integer ranging from -273 to 5526
    values[i] = t
}

min_value = values[0]
min_distance = Math.abs(min_value)

for (i = 1; i < n; ++i) {
    distance = Math.abs(values[i])
    if (distance < min_distance || (distance == min_distance && values[i] > min_value)) {
        min_distance = distance
        min_value = values[i]
    }
}

println min_value
