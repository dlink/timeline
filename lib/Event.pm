# $Id: Event.pm,v 1.4 2006/06/26 01:00:50 david Exp $

# note.  Must disassociate name from entity.

package Event;

@ISA = (qw/Term/);

use strict;
use Term;
use Action;

# STATIC METHODS:

my $DEBUG = 0;
my $sumo = __PACKAGE__;
my $events = {};


# Instance Variables:
#  - time

sub getEvents {
#    return sort keys %$events;
    return values %$events;
}

sub dumpAll {
    use Data::Dumper;
    return Data::Dumper->Dump ([$events], ['events']);
}

# INSTANCE METHODS:

sub init {
    my ($self) = @_;
    $self->{type} = 'event';
    $self->{entity} = $self->{name} if !$self->{entity};
    $self->{name} = $self->{entity} if !$self->{name};
    Entity->new($self->{name}) if !Entity::getEntity($self->{name});
    Action->new($self->{action}) if !Action::getAction($self->{action});
    $events->{$self->{name}} = $self;

    # convert Time:

    if ($self->{time}) {
	print STDERR "time = $self->{time}\n" if $DEBUG;
	my $time_orig = $self->{time};
	my $trx = '\d*';
	my $sep_rx = "[-/:]";
	my $date_rx = qq/($trx) $sep_rx ($trx) $sep_rx ($trx)/;
	my $time_rx = qq/($trx) $sep_rx ($trx) $sep_rx ($trx)/;
	my $clock_rx = '[aApP][mM]';
	my $time2_rx = qq/($trx) $sep_rx ($trx)($clock_rx)/;
	my $num_rx = '[,\d]*';
	my $era_rx = '[bBaA][cCdD]';
	my ($year, $mon, $day, $hour, $min, $sec, $clock,$era) = 
	    (0,0,0,0,0,0,0,'ad');
	if ( $time_orig =~ / ^ \s* ($num_rx) \s* ($era_rx) \s* $ /x ) {
	    ($year, $era) = ($1, $2);
	    $year =~ s/,//g;          # year
	    $era = lc($era);          # era
	    $year *= -1 if $era eq 'bc';
	} elsif ( $time_orig =~ / ^ \s* ($num_rx) \s* $/x ) {
	    $year = $1;
	    $era = 'ad';
	} elsif ( $time_orig =~ / ^ \s* $date_rx \s* ($era_rx|)$/x ) {
	    $mon = $1;               # month 
	    $day = $2;               # day
	    $year = $3;              # year
	    $era = $4||'ad';
	    $year *= -1 if lc($era) eq 'bc';
	} elsif ( $time_orig =~ / ^ \s* $date_rx  \s $time2_rx \s* $ /x ) {
	    $mon = $1;
	    $day = $2;
	    $year = $3;
	    $hour = $4;
	    $min = $5;
	    $clock = lc($6); 
	    $hour += 12 if $clock eq 'pm';
	} else {
	    print STDERR "I do not under stand this time: $time_orig.\n";
	    $year = 1;
	}
	print STDERR "year = ", $year||'', "\n" if $DEBUG;

	$self->{time} = Term->new({ name=>$time_orig,
				    canonical=>
					"$year-$mon-$day\:\:$hour:$min:$sec",
				        type=>'time',
					year=>$year,
					mon=>$mon,
					day=>$day,
					hour=>$hour,
					min=>$min,
					sec=>$sec});
					
	#print $self->{time}->{name}, " - ", $self->{time}->{canonical}, "\n"
    }
}

sub tellAbout {
    my ($self) = @_;
    $self->SUPER::tellAbout;

    # entity
    my $name = $self->get('name');

    # action
    my $action = $self->get('action');
    my $qualifier = '';
    $qualifier = $a->get('qualifier') if ($a = Action::getAction($action));
    $action = "$qualifier $action" if $qualifier && $qualifier ne 'unknown';

    # time:
    my $time = $self->get('time')->get('name');

    return ucfirst($name) . " $action $time.\n";
}


1;
