/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const msg = readline();
output = "";
bn = "";
b = '\0';

for (let i = 0; i < msg.length; i++) {
    c = msg[i];
    // convert to ascii
    a = c.charCodeAt(0);
    // convert to binary
    binary_value = a.toString(2);
    // add leading zeros
    binary = binary_value.padStart(7, '0');
    // add binary value to binary string
    bn += binary;
}

for (let i = 0; i < bn.length; i++) {
    c = bn[i];
    if (c != b){
        if (c == '1'){
            output += " 0 ";
        } else {
            output += " 00 ";
        }
        b = c;
    }
    output += "0";
}

console.log(output.trim());
