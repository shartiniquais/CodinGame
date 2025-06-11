use strict;
use warnings;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

chomp(my $l = <STDIN>);
chomp(my $h = <STDIN>);
chomp(my $t = <STDIN>);
$t = uc $t;

my @asciiArt;
for my $i (0..$h-1) {
    chomp(my $row = <STDIN>);
    push @asciiArt, $row;
}

my @result = ('') x $h;

# Precomputing
my @indices = map { ($_ ge 'A' && $_ le 'Z') ? ord($_) - ord('A') : 26 } split //, $t;

foreach my $index (@indices) {
    for my $i (0..$h-1) {
        my $start = $index * $l;
        my $end = $start + $l;
        $result[$i] .= substr($asciiArt[$i], $start, $l);
    }
}

for my $i (0..$h-1) {
    print "$result[$i]\n";
}
