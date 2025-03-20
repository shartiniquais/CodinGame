using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Solution
{
    static void Main(string[] args)
    {
        string msg = Console.ReadLine();
        string output = "";
        string bn = "";
        char b = '\0'; // Initialize the variable to store the last bit

        foreach (char c in msg)
        {
            int ascii = (int)c; // Convert the character to ASCII
            string binary_value = Convert.ToString(ascii, 2); // Convert the ASCII to binary
            string binary = binary_value.PadLeft(7, '0'); // Pad the binary value to 7 bits
            bn += binary; // Append the binary value to the binary string
        }

        foreach (char c in bn)
        {
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
        Console.WriteLine(output.Trim());
    }
}