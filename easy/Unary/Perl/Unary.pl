use strict;
use warnings;
#use diagnostics;
use 5.32.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

chomp(my $msg = <STDIN>);
my $output = "";
my $bn = "";
my $b = '';

for my $c (split //, $msg) {
    $bn .= sprintf("%07b", ord($c));
}

for my $c (split //, $bn) {
    if ($c ne $b){
        if ($c eq '0'){
            $output .= " 00 ";
        } else {
            $output .= " 0 ";
        }
        $b = $c;
    }
    $output .= "0";
}
sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

say trim($output);