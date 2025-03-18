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
    int n; // the number of temperatures to analyse
    cin >> n; cin.ignore();

    if (n != 0){
        std::vector<int> values(n);

        for (int i = 0; i < n; i++) {
            int t; // a temperature expressed as an integer ranging from -273 to 5526
            cin >> t; cin.ignore();
            values[i]=t;
        }

        int min_value = values[0];
        int min_distance = std::abs(min_value);

        for (int i = 0; i < n; i++) {
            int dist = std::abs(values[i]);

            if (dist < min_distance || (dist == min_distance && values[i] > min_value)){
                min_value = values[i];
                min_distance = dist;
            }
        }
        cout << min_value << endl;
    } else {
        cout << "0" << endl;
    }
}