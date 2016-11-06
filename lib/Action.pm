# $Id: Action.pm,v 1.2 2006/03/05 04:20:12 david Exp $

package Action;

@ISA = (qw/Term/);

use Term;

# STATIC METHODS:

my $DEBUG = 0;
my $sumo = __PACKAGE__;
my $actions = {};


# Instance Variables:
#  - qualifier  (use 'was')

sub getActions {
    return values %$actions;
}
sub getAction {
    return $actions->{$_[0]};
}

sub dumpAll {
    use Data::Dumper;
    return Data::Dumper->Dump ([$actions], ['actions']);
}

# INSTANCE METHODS:

sub init {
    my ($self) = @_;
    $self->{type} = 'action';
    $actions->{$self->{name}} = $self;
}


1;
