import java.util.*;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Solution {

    public static void main(String args[]) {
        Scanner in = new Scanner(System.in);
        String msg = in.nextLine();
        String output = "";
        String bn = "";
        char b = '\0'; // Initialize with a null character

        for (int i = 0; i < msg.length(); i++) {
            char c = msg.charAt(i);
            // convert to ascii
            int ascii = (int) c;
            // convert to binary
            String binary_value = Integer.toBinaryString(ascii);
            // add leading zeros
            while (binary_value.length() < 7) {
                binary_value = "0" + binary_value;
            }
            // add binary value to binary string
            bn += binary_value;
        }

        for (int i = 0; i < bn.length(); i++) {
            char c = bn.charAt(i);
            if (c != b)
            {
                if (c == '1')
                {
                    output +=  " 0 ";
                }
                else if (c == '0')
                {
                    output += " 00 ";
                }
                b = c; // Update the previous bit
            }
            output += "0"; // Add a unary '0' for each bit
        }

        // trim output
        output = output.trim();

        System.out.println(output);
    }
}