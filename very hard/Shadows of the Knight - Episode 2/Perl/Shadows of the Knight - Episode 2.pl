use strict;
use warnings;
use 5.32.1;
use List::Util qw(min max);

select(STDOUT); $| = 1; # DO NOT REMOVE

###################################################################################################################
# Function narrow_dimension:                                                                                      #
#   Updates the search interval in one dimension                                                                  #
#   based on the feedback and the comparison between                                                              #
#   the previous position (x0 or y0) and the current position (x or y).                                           #
#                                                                                                                 #
# Parameters:                                                                                                     #
#   $prev : previous position on the axis (x0 or y0)                                                              #
#   $current : current position on the axis (x or y)                                                              #
#   $min : current lower bound (x_min or y_min)                                                                   #
#   $max : current upper bound (x_max or y_max)                                                                   #
#   $info : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                      #
#                                                                                                                 #
# For SAME, if (x0+x) (or y0+y) is even, the bomb is exactly in the middle.                                       #
# For WARMER/COLDER, we deduce which side of the interval to keep                                                 #
#   - WARMER: if moved closer to bomb, keep nearer half                                                            #
#   - COLDER: if moved further, discard nearer half                                                               #
###################################################################################################################
sub narrow_dimension {
    my ($prev, $current, $min, $max, $info) = @_;
    my $sum = $prev + $current;

    if ($info eq 'SAME') {
        if ($sum % 2 == 0) {
            my $middle = int($sum / 2);
            $min = $middle;
            $max = $middle;
        }
    }
    elsif ($info eq 'WARMER') {
        if ($current > $prev) {
            my $new_lower = int($sum / 2) + 1;
            $min = $new_lower if $new_lower > $min;
        } elsif ($current < $prev) {
            my $new_upper = ($sum % 2 == 0) ? int($sum / 2) - 1 : int($sum / 2);
            $max = $new_upper if $new_upper < $max;
        }
    }
    elsif ($info eq 'COLDER') {
        if ($current > $prev) {
            my $new_upper = ($sum % 2 == 0) ? int($sum / 2) - 1 : int($sum / 2);
            $max = $new_upper if $new_upper < $max;
        } elsif ($current < $prev) {
            my $new_lower = int($sum / 2) + 1;
            $min = $new_lower if $new_lower > $min;
        }
    }

    return ($min, $max);
}

##############################################################
# Function narrow:                                           #
# Applies narrow_dimension on x as long as                   #
# the horizontal interval is not reduced to a single value,  #
# then on y if x is already determined.                      #
##############################################################
sub narrow {
    my ($x0, $y0, $x, $y, $x_min, $x_max, $y_min, $y_max, $info) = @_;

    print STDERR "narrow: x0: $x0 y0: $y0 x_min: $x_min x_max: $x_max y_min: $y_min y_max: $y_max info: $info\n";

    if ($x_min != $x_max) {
        ($x_min, $x_max) = narrow_dimension($x0, $x, $x_min, $x_max, $info);
    } elsif ($y_min != $y_max) {
        ($y_min, $y_max) = narrow_dimension($y0, $y, $y_min, $y_max, $info);
    }

    print STDERR "narrow : x_min: $x_min x_max: $x_max y_min: $y_min y_max: $y_max\n";
    return ($x_min, $x_max, $y_min, $y_max);
}

# Read initial input
my $tokens;
chomp($tokens = <STDIN>);
my ($w, $h) = split(/ /, $tokens);
chomp(my $n = <STDIN>);
chomp($tokens = <STDIN>);
my ($x0, $y0) = split(/ /, $tokens);

my $x = $x0;
my $y = $y0;
my ($x_min, $x_max) = (0, $w - 1);
my ($y_min, $y_max) = (0, $h - 1);

# Main loop
while (1) {
    chomp(my $info = <STDIN>);

    ($x_min, $x_max, $y_min, $y_max) = narrow($x0, $y0, $x, $y, $x_min, $x_max, $y_min, $y_max, $info);

    $x0 = $x;
    $y0 = $y;

    if ($x_min != $x_max) {
        if ($x0 == 0 && $x_max + $x_min + 1 != $w) {
            $x = int((3 * $x_min + $x_max) / 2) - $x0;
        } elsif ($x0 == $w - 1 && $x_max + $x_min + 1 != $w) {
            $x = int(($x_min + 3 * $x_max) / 2) - $x0;
        } else {
            $x = $x_max + $x_min - $x0;
        }

        $x = $x0 + 1 if $x == $x0;
        $x = 0 if $x < 0;
        $x = $w - 1 if $x > $w - 1;
    } else {
        if ($x != $x_min) {
            $x = $x_min;
            $x0 = $x;
            print "$x $y\n";
            chomp($info = <STDIN>);
        }

        if ($y_min != $y_max) {
            if ($y0 == 0 && $y_max + $y_min + 1 != $h) {
                $y = int((3 * $y_min + $y_max) / 2) - $y0;
            } elsif ($y0 == $h - 1 && $y_max + $y_min + 1 != $h) {
                $y = int(($y_min + 3 * $y_max) / 2) - $y0;
            } else {
                $y = $y_max + $y_min - $y0;
            }

            $y = $y + 1 if $y == $y0;
            $y = 0 if $y < 0;
            $y = $h - 1 if $y > $h - 1;
        } else {
            $y = $y_min;
        }
    }

    print "$x $y\n";
}
