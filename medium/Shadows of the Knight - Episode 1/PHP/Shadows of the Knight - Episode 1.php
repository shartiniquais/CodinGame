<?php
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

// $W: width of the building.
// $H: height of the building.
fscanf(STDIN, "%d %d", $w, $h);
// $_: maximum number of turns before game over. (not used)
fscanf(STDIN, "%d", $_);
fscanf(STDIN, "%d %d", $x0, $y0);

$left = 0;
$right = $w - 1;
$top = 0;
$bottom = $h - 1;

// game loop
while (TRUE)
{
    // $bombDir: the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    fscanf(STDIN, "%s", $bombDir);

    if (strpos($bombDir, "U") !== false) {
        $bottom = $y0 - 1;
    } else if (strpos($bombDir, "D") !== false) {
        $top = $y0 + 1;
    }
    if (!strpos($bombDir, "L") !== false) {
        $right = $x0 - 1;
    } else if (strpos($bombDir, "R") !== false) {
        $left = $x0 + 1;
    }

    $x0 = intdiv(($left + $right), 2);
    $y0 = intdiv(($top + $bottom), 2);

    echo("$x0 $y0\n");
}
?>