input = new Scanner(System.in);

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

l = input.nextInt()
h = input.nextInt()
input.nextLine()
t = input.nextLine().toUpperCase()
ascii = new ArrayList<String>(h)
for (i = 0; i < h; ++i) {
    row = input.nextLine()
    ascii.add(row)
}

result = new ArrayList<>()
for (i = 0; i < h; ++i) {
    result.add("")
}

for (int j = 0; j < t.length(); ++j) {
    char c = t.charAt(j)
    if ('A' <= c && c <= 'Z') {
        index = (int) c - (int) 'A'
    } else {
        index = 26
    }

    for (i = 0; i < h; ++i) {
        result[i] += ascii[i].substring(index * l, index * l + l)
    }
}

for (i = 0; i < h; ++i) {
    println(result[i])
}