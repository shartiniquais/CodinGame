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
    int w; // width of the building.
    int h; // height of the building.
    cin >> w >> h; cin.ignore();

    int _; // maximum number of turns before game over. (not used)
    cin >> _; cin.ignore();

    int x0;
    int y0;
    cin >> x0 >> y0; cin.ignore();

    int left, right, top, bottom;
    left = 0;
    right = w - 1;
    top = 0;
    bottom = h - 1;

    // game loop
    while (1) {
        string bomb_dir; // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
        cin >> bomb_dir; cin.ignore();

        if (bomb_dir.find("U") != string::npos) {
            bottom = y0 - 1;
        } else if (bomb_dir.find("D") != string::npos) {
            top = y0 + 1;
        }
        if (bomb_dir.find("L") != string::npos) {
            right = x0 - 1;
        } else if (bomb_dir.find("R") != string::npos) {
            left = x0 + 1;
        }

        x0 = (left + right) / 2;
        y0 = (top + bottom) / 2;

        cout << x0 << " " << y0 << endl; // the location of the next window Batman should jump to.
    }
}