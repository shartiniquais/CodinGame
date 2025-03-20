using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;

/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/
class Player
{
    static void Main(string[] args)
    {

        // game loop
        while (true)
        {
            int biggest=0;
            int num=0;
            for (int i = 0; i < 8; i++)
            {
                int mountainH = int.Parse(Console.ReadLine()); // represents the height of one mountain.
                if (mountainH>biggest){
                    biggest = mountainH;
                    num = i;
                }
            }

            // Write an action using Console.WriteLine()
            // To debug: Console.Error.WriteLine("Debug messages...");

            Console.WriteLine(num); // The index of the mountain to fire on.

        }
    }
}