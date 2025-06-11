<?php
fscanf(STDIN, "%d", $l);
fscanf(STDIN, "%d", $h);
$t = strtoupper(stream_get_line(STDIN, 256 + 1, "\n"));

$asciiArt = [];
for ($i = 0; $i < $h; $i++) {
    $asciiArt[$i] = stream_get_line(STDIN, 1024 + 1, "\n");
}

$result = array_fill(0, $h, '');

$chars = str_split($t);
foreach ($chars as $c) {
    $index = ctype_alpha($c) ? ord($c) - ord('A') : 26;

    for ($i = 0; $i < $h; $i++) {
        $start = $index * $l;
        $result[$i] .= substr($asciiArt[$i], $start, $l);
    }
}

foreach ($result as $line) {
    echo $line . "\n";
}
?>
