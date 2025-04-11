using System;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Player
{
    static void Main(string[] args)
    {
        string[] inputs;
        inputs = Console.ReadLine().Split(' ');
        int w = int.Parse(inputs[0]); // width of the building.
        int h = int.Parse(inputs[1]); // height of the building.
        int _ = int.Parse(Console.ReadLine()); // maximum number of turns before game over. (not used)
        inputs = Console.ReadLine().Split(' ');
        int x0 = int.Parse(inputs[0]);
        int y0 = int.Parse(inputs[1]);

        int left = 0;
        int right = w - 1;
        int top = 0;
        int bottom = h - 1;

        // game loop
        while (true)
        {
            string bombDir = Console.ReadLine(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

            if (bombDir.Contains("U"))
            {
                bottom = y0 - 1;
            } else if (bombDir.Contains("D"))
            {
                top = y0 + 1;
            }
            if (bombDir.Contains("L"))
            {
                right = x0 - 1;
            } else if (bombDir.Contains("R"))
            {
                left = x0 + 1;
            }
            
            x0 = (left + right) / 2;
            y0 = (top + bottom) / 2;

            Console.WriteLine(x0 + " " + y0);
        }
    }
}