# $Id: Configx.pm,v 1.1 2006/06/16 05:36:01 david Exp $

package Configx;

use strict;

$|++;

my $datadir = '../data';
my $face = 'purple';

sub new { return bless {} }
sub getdatadir { return '../data' }

1;
