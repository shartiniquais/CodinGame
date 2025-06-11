#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int main()
{
    int l;
    scanf("%d", &l);
    int h;
    scanf("%d", &h); fgetc(stdin);
    char t[257];
    scanf("%[^\n]", t); fgetc(stdin);

    // Make t uppercase
    for (int i = 0; t[i] != '\0'; i++) {
        if (t[i] >= 'a' && t[i] <= 'z') {
            t[i] = t[i] - 32;
        }
    }

    // asciiArt is an array containing every row of the ASCII art
    char asciiArt[100][1025];
    for (int i = 0; i < h; i++) {
        scanf("%[^\n]", asciiArt[i]); fgetc(stdin);
    }

    // Initialize result with empty strings
    char result[100][1025] = { "" };

    // For each character in the text
    for (int i = 0; i < strlen(t); i++) {
        char character = t[i];

        // Calculate the index of the character in the ASCII art
        int index;
        if (character >= 'A' && character <= 'Z') {
            index = character - 'A';
        } else {
            index = 26; // Index for '?' for other characters
        }

        // Build the entire string for each row
        for (int j = 0; j < h; j++) {
            strncat(result[j], &asciiArt[j][index * l], l);
        }
    }

    // Print the result
    for (int i = 0; i < h; i++) {
        printf("%s\n", result[i]);
    }

    return 0;
}