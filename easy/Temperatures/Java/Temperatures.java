import java.util.Scanner;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Solution {

    public static void main(String args[]) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt(); // the number of temperatures to analyse

        if (n == 0) {
            System.out.println(0);
            return;
        }

        // variable to store the temperatures
        int[] values = new int[n];

        for (int i = 0; i < n; i++) {
            int t = in.nextInt(); // a temperature expressed as an integer ranging from -273 to 5526
            values[i] = t;
        }

        int min_value = values[0];
        int min_distance = Math.abs(min_value);

        for (int i = 1; i < n; i++) {
            int distance = Math.abs(values[i]);
            if (distance < min_distance || (distance == min_distance && values[i] > min_value)) {
                min_value = values[i];
                min_distance = distance;
            }
        }

        // Write an answer using System.out.println()
        // To debug: System.err.println("Debug messages...");

        System.out.println(min_value);
    }
}