use strict;
use warnings;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# CodinGame planet is being attacked by slimy insectoid aliens.
# <---
# Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.

# game loop
while (1) {
    chomp(my $enemy1 = <STDIN>); # name of enemy 1
    chomp(my $dist1 = <STDIN>); # distance to enemy 1
    chomp(my $enemy2 = <STDIN>); # name of enemy 2
    chomp(my $dist2 = <STDIN>); # distance to enemy 2
    
    # Write an action using print
    # To debug: print STDERR "Debug messages...\n";

    # Determine which enemy is closer and print its name
    print $dist1 < $dist2 ? "$enemy1\n" : "$enemy2\n";
}