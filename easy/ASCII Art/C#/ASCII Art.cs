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
        int L = int.Parse(Console.ReadLine());
        int H = int.Parse(Console.ReadLine());
        string T = Console.ReadLine().ToUpper();

        List<string> asciiArt = new List<string>();
        for (int i = 0; i < H; i++)
        {
            string row = Console.ReadLine();
            asciiArt.Add(row);
        }

        string[] result = new string[H];
        for (int i = 0; i < H; i++)
        {
            result[i] = "";
        }

        foreach (char c in T)
        {
            int index;
            if (c >= 'A' && c <= 'Z')
            {
                index = c - 'A';
            }
            else
            {
                index = 26; // For non-alphabet characters, use '?'
            }

            for (int i = 0; i < H; i++)
            {
                result[i] += asciiArt[i].Substring(index * L, L);
            }
        }

        foreach (string line in result)
        {
            Console.WriteLine(line);
        }
    }
}
