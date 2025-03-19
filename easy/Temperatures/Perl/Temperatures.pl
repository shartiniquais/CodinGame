use strict;
use warnings;
#use diagnostics;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

my $tokens;
my @inputs;

chomp(my $n = <STDIN>); # the number of temperatures to analyse

if ($n == 0) {
    print "0\n";
    exit;
}

# values to store the temperatures
my @values = [];

chomp($tokens=<STDIN>);
@inputs = split(/ /,$tokens);
for my $t (@inputs) {
    push(@values, $t);
}

my $min = 5526;
my $min_distance = 5526;

for my $t (@values) {
    my $distance = abs($t);
    if ($distance < $min_distance) {
        $min_distance = $distance;
        $min = $t;
    } elsif ($distance == $min_distance) {
        $min = $t if $t > 0;
    }
}

# Write an answer using print
# To debug: print STDERR "Debug messages...\n";

print "$min\n";