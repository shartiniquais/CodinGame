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
        int n = int.Parse(Console.ReadLine()); // the number of temperatures to analyse
        string[] inputs = Console.ReadLine().Split(' ');

        if (n!=0){

            int[] values = new int[n];

            for (int i = 0; i < n; i++){
                int t = int.Parse(inputs[i]);// a temperature expressed as an integer ranging from -273 to 5526
                values[i]=t;
            }

            int minValue = values[0];
            int minDistance = Math.Abs(minValue);

            for (int i = 0; i < n; i++){
                int dist = Math.Abs(values[i]);

                if (dist < minDistance || (dist == minDistance && values[i] > minValue)) {
                    minValue = values[i];
                    minDistance = dist;
                }
            }

            Console.WriteLine(minValue);

        } else {
            Console.WriteLine("0");
        }
    }
}