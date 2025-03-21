input = new Scanner(System.in);

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

msg = input.nextLine()
output = ""
bn = ""
b = '\0'

// for each character in the message
for (int i = 0; i < msg.length(); i++) {
    // get the character
    c = msg.charAt(i)
    // convert the character to ascii
    a = c as int
    // convert the ascii to binary
    binary_value = Integer.toBinaryString(a)
    // if the binary value is less than 7, add 0s to the front
    binary = binary_value.padLeft(7, '0')
    // add the binary value to the binary string
    bn += binary
}

for (int i = 0; i < bn.length(); i++) {
    // get the character
    c = bn.charAt(i)
    // if the character is different from the previous character
    if (c != b){
        if (c == '1'){
            output += " 0 "
        } else {
            output += " 00 "
        }
        b = c
    }
    output += "0"
}

// trim the output
output = output.trim()

println output