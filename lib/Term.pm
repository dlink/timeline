# $Id: Term.pm,v 1.2 2006/03/05 04:20:12 david Exp $

package Term;

#use Action;
#use Entity;
#use strict;

#$|++;


# STATIC METHODS:

my $DEBUG = 0;

my $sumo = __PACKAGE__;

my $terms = {};

sub loadData { }

sub getTerms {
    return sort keys %$terms;
}

sub dumpAll {
    use Data::Dumper;
    return Data::Dumper->Dump ([$terms], ['terms']);
}

# INSTANCE METHODS:

#-------------------------------------------------------
# Method:  new ( event : HASHREF ) 
# Return:  OBJECT
# Instance Variables:
#  - name
#-------------------------------------------------------
sub new {
    print STDERR "$sumo->new ( @_ )\n" if $DEBUG;
    my ($_type, $term) = @_;
    my $class = ref($_type) || $_type;
    my $self = {};
    if (!ref($term)) {
	$self->{name} = $term||'unknown';
    } elsif (ref($term) eq 'HASH') {
	$self = $term;
    } else {
	die "$sumo->new, invalid parameter type: $term\n";
    }
    bless( $self, $class); 
    $self->init;
    $terms->{$self->{name}} = $self;
    # would like to get this to work:
    #eval (qq/\${${self}->{type}s}->{ xx } = \$self/);
    return $self;
}

sub init { }

sub get {
    my ($self, $attrib) = @_;
    return $self->{$attrib} || 'unknown';
}

sub dump {
    use Data::Dumper;
    return Data::Dumper->Dump ([$_[0]], [$_[0]->{name}]);
}

sub tellAbout {
    my ($self) = @_;
    my $o = '';
    
    
    if ($self->{category}) {
	my $category = $self->{category};
	$o .= ucfirst($self->{name}) . " is a $category";
	while ($e = Entity::getEntity($category)) {
	    $category = $e->get('category');
	    $o .= ", $category"
	} 
	$o .= ".\n";
    } else {
	$o .= ucfirst($self->{name}) ." is a $self->{type}.\n";
    }

#    $o .= 
#	"It has the following attributes: " .
#	join (", ", sort keys %{$self}) . ".\n";

    $o;
}

1;
