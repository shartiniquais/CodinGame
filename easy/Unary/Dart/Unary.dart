import 'dart:io';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    String msg = readLineSync();
    String output = '';
    String bn = '';
    String b = '';

    for (var c in msg.runes.map((r) => String.fromCharCode(r))) {
      // Convert the character to ascii
      int ascii = c.codeUnitAt(0);
      // Convert the ascii to binary and pad it to 7 bits
      String binary = ascii.toRadixString(2).padLeft(7, '0');
      // Add the binary value to the binary string
      bn += binary;
    }

    // Loop through the binary string
    for (var c in bn.split('')) {
      if (c != b){
        if (c == '1'){
          output += " 0 ";
        }
        else{
          output += " 00 ";
        }
        b = c;
      }
      output += "0";
    }

  // trim the output
  output = output.trim();

  print(output);
}