#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

int main()
{
    string msg;
    getline(cin, msg);

    string out = "";
    string bn = "";
    char b = '\0'; // Initialize with a null character

    // Convert the input message to a binary string
    for (char c : msg) {
        int ascii = (int)c;

        // Convert ASCII value to binary (7 bits)
        string binary = "";
        for (int j = 6; j >= 0; j--) {
            binary = to_string(ascii % 2) + binary;
            ascii /= 2;
        }
        bn += binary; // Append the binary representation
    }

    // Convert the binary string to unary
    for (char c : bn) {
        if (c != b) { // Check if the current bit is different from the previous one
            if (c == '1') {
                out += (out.empty() ? string("") : string(" ")) + "0 ";
            } else if (c == '0') {
                out += (out.empty() ? string("") : string(" ")) + "00 ";
            }
            b = c; // Update the previous bit
        }
        out += "0"; // Add a unary '0' for each bit
    }

    cout << out << endl;
}