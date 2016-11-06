# $Id: Math.pm,v 1.2 2006/03/05 04:20:12 david Exp $

package Math;

sub min {
    my $m = shift @_||0;
    for (@_) { $m = $_ if $_ < $m; } $m
}

sub max {
    my $m = shift @_||0;
    for (@_) { $m = $_ if $_ > $m; } $m
}

sub round {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}

1;
