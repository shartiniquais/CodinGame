#include <Foundation/Foundation.h>

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
int main(int argc, const char * argv[]) {
    int n; // the number of temperatures to analyse
    scanf("%d", &n);

    if (n == 0) {
        printf("0\n");
        return 0;
    }

    // Array to store all temperatures
    NSMutableArray *values = [NSMutableArray new];

    for (int i = 0; i < n; i++) {
        int t; // a temperature expressed as an integer ranging from -273 to 5526
        scanf("%d", &t);
        [values addObject:@(t)]; // Wrap the integer in an NSNumber
    }

    int min_value = [[values objectAtIndex:0] intValue];
    int min_distance = abs(min_value);

    for (int i = 1; i < n; i++) {
        int current_value = [[values objectAtIndex:i] intValue]; // Unwrap the NSNumber to get the integer
        int distance = abs(current_value);
        if (distance < min_distance || (distance == min_distance && current_value > min_value)) {
            min_distance = distance;
            min_value = current_value;
        }
    }

    // Write an answer using printf(). DON'T FORGET THE TRAILING NEWLINE \n
    // To debug: fprintf(stderr, "Debug messages\n");

    printf("%d\n", min_value);
    return 0;
}