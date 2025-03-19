<?php
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

// $n: the number of temperatures to analyse
fscanf(STDIN, "%d", $n);

if ($n == 0)
{
    echo "0\n";
    return;
}

$inputs = explode(" ", fgets(STDIN));
$min = 5526;
$minDist = 5526;
for ($i = 0; $i < $n; $i++)
{
    $t = intval($inputs[$i]); // a temperature expressed as an integer ranging from -273 to 5526
    $dist = abs($t);
    if ($dist < $minDist || ($dist == $minDist && $t > 0))
    {
        $min = $t;
        $minDist = $dist;
    }
}

echo "$min\n";