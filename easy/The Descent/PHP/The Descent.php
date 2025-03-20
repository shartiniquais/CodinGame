<?php
/**
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 **/


// game loop
while (TRUE)
{
    $biggest = 0;
    $num = 0;

    for ($i = 0; $i < 8; $i++)
    {
        // $mountainH: represents the height of one mountain.
        fscanf(STDIN, "%d", $mountainH);

        if ($biggest < $mountainH){
            $biggest = $mountainH;
            $num = $i;
        }
    }

    // Write an action using echo(). DON'T FORGET THE TRAILING \n
    // To debug: error_log(var_export($var, true)); (equivalent to var_dump)

    echo("$num\n"); // The index of the mountain to fire on.
}
?>