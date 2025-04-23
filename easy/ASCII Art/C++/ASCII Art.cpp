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
    int l;
    cin >> l; cin.ignore();
    int h;
    cin >> h; cin.ignore();
    string t;
    getline(cin, t);
    // put t in uppercase
    transform(t.begin(), t.end(), t.begin(), ::toupper);

    vector<string> asciiArt(h);
    for (int i = 0; i < h; i++) {
        string row;
        getline(cin, row);
        asciiArt[i] = row;
    }

    vector<string> result(h);

    // For each character in the text
    for (int i = 0; i < t.size(); i++) {
        char c = t[i];
        int index;
        // Calculate the index of the character in the ASCII art
        if (c >= 'A' && c <= 'Z') {
            index = c - 'A';
        } else {
            index = 26; // Index for '?' for other characters
        }

        for (int j = 0; j < h; j++) {
            // Build the entire string for each row
            result[j] += asciiArt[j].substr(index * l, l);
        }
    }

    for (int i = 0; i < h; i++) {
        cout << result[i] << endl;
    }
}