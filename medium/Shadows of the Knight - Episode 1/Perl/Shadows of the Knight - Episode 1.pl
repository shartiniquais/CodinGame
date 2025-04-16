use strict;
use warnings;
#use diagnostics;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

my $tokens;

# w: width of the building.
# h: height of the building.
chomp($tokens=<STDIN>);
my ($w, $h) = split(/ /,$tokens);
chomp(my $n = <STDIN>); # maximum number of turns before game over.
chomp($tokens=<STDIN>);
my ($x0, $y0) = split(/ /,$tokens);

my $left = 0;
my $right = $w - 1;
my $top = 0;
my $bottom = $h - 1;

# game loop
while (1) {
    chomp(my $bomb_dir = <STDIN>); # the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if (index($bomb_dir, "U") != -1) {
        $bottom = $y0 - 1;
    }
    if (index($bomb_dir, "D") != -1) {
        $top = $y0 + 1;
    }
    if (index($bomb_dir, "L") != -1) {
        $right = $x0 - 1;
    }
    if (index($bomb_dir, "R") != -1) {
        $left = $x0 + 1;
    }

    $x0 = int(($left + $right) / 2);
    $y0 = int(($top + $bottom) / 2);

    print "$x0 $y0\n";
}