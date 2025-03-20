use strict;
use warnings;
#use diagnostics;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# The while loop represents the game.
# Each iteration represents a turn of the game
# where you are given inputs (the heights of the mountains)
# and where you have to print an output (the index of the mountain to fire on)
# The inputs you are given are automatically updated according to your last actions.


# game loop
while (1) {
    my $biggest = 0;
    my $num = 0;

    for my $i (0..7) {
        chomp(my $mountain_h = <STDIN>); # represents the height of one mountain.
        if ($biggest < $mountain_h) {
            $biggest = $mountain_h;
            $num = $i
        }
    }
    
    # Write an action using print
    # To debug: print STDERR "Debug messages...\n";

    print "$num\n"; # The index of the mountain to fire on.
}