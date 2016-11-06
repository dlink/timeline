# $Id: Timeline.pm,v 1.9 2006/06/26 02:44:29 david Exp $

package Timeline;

use strict;

use Configx;
use Action;
use Entity;
use Event;
use Math;
use EventLister;

$|++;

my $DEBUG = 0;
my $sumo = __PACKAGE__;

#-----------------------------------------------------
#  Method:  new ( type , data )
#           data can be datatext or a datafile
#  Return:  OBJ Timeline
#-----------------------------------------------------
sub new {
  print STDERR "$sumo->new ( @_ )\n" if $DEBUG;
  my ($type, $data) = @_;
  my $self = {};
  $self->{eventLister} = 0;

  my $c = Configx->new; 
  my $datadir = $c->getdatadir;

  if ($data =~ '\n' || ! -f "$datadir/$data") {
    $self->{datatext} = $data;
    $self->{datafile} = '';
  } else {
    $self->{datafile} = $data || 'universe.data';
    $self->{datatext} = '';
  }
  print STDERR "$sumo->new: datafile=$self->{datafile}\n" if $DEBUG;
    $self->{dataloaded} = 0;
    return bless $self;
}

sub setDataText {
  my ($self, $datatext) = @_;
  $self->{eventLister} = EventLister->new($datatext);
  $self->{dataloaded} = 1;
}
  
sub loadData {
    my ($self) = @_;
    my $datatext = $self->{datatext};
    my $datafile = $self->{datafile};
    if ($datafile) {
      my $c = Configx->new;
      my $datadir = $c->getdatadir;
      $self->{eventLister} = EventLister->new("$datadir/$datafile");
    } else {
      $self->{eventLister} = EventLister->new($datatext);
    }
    $self->{dataloaded} = 1;
}

#-----------------------------------------------------
#  Method: getData ()
#  Return: SCALAR, String list of Events
#-----------------------------------------------------
sub getData {   
  print STDERR "getData ( @_ )\n" if $DEBUG;

  my $self = shift;
  return $self->{datatext} if $self->{datatext};
  my $output = '';
  for (sort {$a->get('time')->get('year') <=> 
	       $b->get('time')->get('year')} Event::getEvents) {
    $output .= $_->tellAbout;
  }
  $self->{datatext} = $output;
  return $output;
}

sub getErrorMsg { return $_[0]->{eventLister}->getErrorMsg }

sub drawTimeline {
  print STDERR "Timeline::drawTimeline ( @_ )\n" if $DEBUG;
  my ($self) = @_;
    $self->loadData if !$self->{dataloaded};

    my $output = '';
    #$output .= "\nTimeline:\n\n";

    my ($minyear, $maxyear) = (9999,-300000000);
    my $virt_grid = 60;
    my $i = 0;
    for (Event::getEvents) {
	#$output .= $_->tellAbout;
	my $event_time = $_->get('time');
	my $year = $event_time->get('year');
	$minyear = Math::min($minyear, $year);
	$maxyear = Math::max($maxyear, $year);
    }
    $output .= "\n";
    my $delta = $maxyear - $minyear;
    my $step = $delta / $virt_grid;
    my $offset = -$minyear;

    if ($DEBUG) {
	$output .= "minyear = $minyear\n";
	$output .= "maxyear = $maxyear\n";
	$output .= "delta   = $delta\n";
	$output .= "step    = $step\n";
	$output .= "offset  = $offset\n";
    }

    my %tick = ();
    for (Event::getEvents) {
	if ($DEBUG) {
	    $output .= "event = ". $_->get('name'). ", " ;
	    $output .= "year = ". $_->get('time')->get('year'). "\n";
	}
	my $xplot = Math::round(($_->get('time')->get('year')+$offset)/$step);
	#$output .= "xplot=$xplot\n";
	push @{$tick{$xplot}}, $_;
    }

    # Print Tag Labels:

    for (my $i = 0; $i <= $virt_grid; ++$i) {
	if ($tick{$i}) {
	    for (@{$tick{$i}}) {
		$output .= $_->get('name'). "\n";
		for (my $j = 0; $j <= $i-1; ++$j) { 
		    if ($tick{$j}) {
			$output .= "|";
		    } else {
			$output .= ' ';
		    }
		}
	    }
	    $output .= '|';
	} else {
	    $output .= " ";
	}
    }
    $output .= "\n";

    # Print Timeline:

    my $timeline_key = '';
    for (my $i = 0; $i <= $virt_grid; ++$i) {
	if ($tick{$i}) {
	    $output .= "|";
	    for (@{$tick{$i}}) {
		$timeline_key .=  
		    $_->get('time')->get('name') . ": " .
		    $_->get('name') . "\n";
	    }
	} else {
	    $output .= "_";
	}
    }
    $output .= "\n\n";
    #$output .= "\n$timeline_key";
    return $output;
}

1;
