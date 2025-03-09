#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

int main()
{
    // the number of temperatures to analyse
    int n;
    scanf("%d", &n);

    if (n != 0) {
        int values[n];

        for (int i = 0; i < n; i++) {
            scanf("%d", &values[i]);
        }

        int min_value = values[0];
        int min_distance = abs(min_value);

        for (int i = 1; i < n; i++) {
            int dist = abs(values[i]);

            if (dist < min_distance || (dist == min_distance && values[i] > min_value)) {
                min_value = values[i];
                min_distance = dist;
            }
        }
        printf("%d\n", min_value);
    } else {
        printf("0\n");
    }

    // Write an answer using printf(). DON'T FORGET THE TRAILING \n
    // To debug: fprintf(stderr, "Debug messages...\n");
    return 0;
}