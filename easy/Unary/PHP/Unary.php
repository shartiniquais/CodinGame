<?php
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

$MSG = stream_get_line(STDIN, 100 + 1, "\n");

$output = "";
$bn = "";
$b = '';

foreach(str_split($MSG) as $c) {
    $bn .= sprintf("%07b", ord($c));
}

foreach(str_split($bn) as $c) {
    if($b != $c) {
        if($c == '0') {
            $output .= " 00 ";
        } else {
            $output .= " 0 ";
        }
        $b = $c;
    }
    $output .= "0";
}

echo trim($output);