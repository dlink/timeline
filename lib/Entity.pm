# $Id: Entity.pm,v 1.2 2006/03/05 04:20:12 david Exp $

package Entity;

@ISA = (qw/Term/);

use Term;

# STATIC METHODS:

my $DEBUG = 0;
my $sumo = __PACKAGE__;
my $entities = {};

# Instance Variables:
#  - category ('similarities')

sub getEntities {
    #return sort keys %$entities;
    return values %$entities;
}

sub getEntity {
    return $entities->{$_[0]};
}

sub dumpAll {
    use Data::Dumper;
    return Data::Dumper->Dump ([$entities], ['entities']);
}

# INSTANCE METHODS:

sub init {
    my ($self) = @_;
    $self->{type} = 'entity';
    $entities->{$self->{name}} = $self;
}


1;
