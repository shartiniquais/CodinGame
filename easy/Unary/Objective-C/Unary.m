#include <Foundation/Foundation.h>

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

int main()
{
    char msg[101];
    scanf("%[^\n]", msg);
    char out[1024] = "";
    char b[1024] = "";

    // Convert each character to binary and append to `b`
    for (int i = 0; i < strlen(msg); i++) {
        char c = msg[i];

        // Get ASCII value of character
        int ascii = (int)c;

        // Convert ASCII value to binary (7 bits)
        char binary[8] = ""; // Temporary buffer for binary representation
        for (int j = 6; j >= 0; j--) { // Process 7 bits
            binary[j] = (ascii % 2) + '0';
            ascii /= 2;
        }
        strcat(b, binary); // Append binary representation to `b`
    }

    // Construct the unary output
    char bnum = '\0'; // Track the current binary digit
    for (int i = 0; i < strlen(b); i++) {
        char c = b[i];

        if (c != bnum) { // Transition between `1` and `0`
            if (bnum != '\0') {
                strcat(out, " "); // Add a space between groups
            }
            if (c == '1') {
                strcat(out, "0 ");
            } else {
                strcat(out, "00 ");
            }
            bnum = c;
        }
        strcat(out, "0");
    }

    printf("%s\n", out);

    return 0;
}
