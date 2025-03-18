<?php
// game loop
while (TRUE)
{
    fscanf(STDIN, "%s", $enemy1); // name of enemy 1
    fscanf(STDIN, "%d", $dist1); // distance to enemy 1
    fscanf(STDIN, "%s", $enemy2); // name of enemy 2
    fscanf(STDIN, "%d", $dist2); // distance to enemy 2

    // Write an action using echo(). DON'T FORGET THE TRAILING \n

    // Determine which enemy is closer and print its name
    echo ($dist1 < $dist2 ? $enemy1 : $enemy2) . "\n";
}
