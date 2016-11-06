# $Id: EventLister.pm,v 1.4 2006/06/26 03:00:51 david Exp $

package EventLister;

use strict;
use Configx;
use English;

# STATIC METHODS:

my $DEBUG = 0;
my $DEBUG_DETAIL = 0;

my $sumo = __PACKAGE__;

#-------------------------------------------------------
# Method:   new ( datatext or datafile )
# Behavior: Initializes All Events.
#-------------------------------------------------------
sub new {
    print STDERR "$sumo->new ( @_ )\n" if $DEBUG;
    my ($_type, $data) = @_;
    my $class = ref($_type) || $_type;
    my $self = {};
    $self->{unrecognized_list} = [];
    die "$sumo->new, must specify data or datafile\n" if !$data;
    my $c = Configx->new;
    my $datadir = $c->getdatadir;

    if ($data =~ '\n' || ! -f "$datadir/$data") {
      $self->{datafile} = '';
      $self->{datatext} = $data;
    } else {
      $self->{datafile} = $data;
      $self->{datatext} = '';
    }
    bless( $self, $class); 
    $self->load_text;
    return $self;
}

sub load_text {
  print STDERR "$sumo->load_text ( @_ )\n" if $DEBUG;
    my $self = shift;
    my $data = $self->{datatext};
    my $datafile = $self->{datafile};
    if ($datafile) {
      open F, "<$datafile" or die "$! $datafile\n";
      undef $/;
      $data = (<F>);
      close F;
    }

    #my @sentences = map {$_ =~ s/\n*//g} split /\./, $data;
    my @sentences0 = split /\./, $data;
    my @sentences = ();
    for (@sentences0) {
	$_ =~ s/\n*//g;
	$_ =~ s/\r\n*//g;
	push @sentences, $_;
    }
    (my $last = pop @sentences) =~ s/\s*//;
    push @sentences, $last if $last;

    for (@sentences) {
	chomp;
	if (m/\b(was|) born\s*(in|on|)/ ||
	    m/\b began \s*(in|on|)/x ||
	    m/was \s*(in|on|)/ ||
	    m/expressed \s*(in|on|)/ ||
	    m/was formed \s*(in|on|)/ ||
	    m/formed \s*(in|on|)/x ||
	    m/happened \s*(in|on})/x ||
	    m/\b \s+ was \s*(in|on|)/x
	   ) {
	    my $subject_phrase = $PREMATCH;
	    my $verb_phrase    = $MATCH;
	    (my $direct_object  = $POSTMATCH) =~ s/^\s*//;
	    $subject_phrase =~ s/\s*$//;
	    print STDERR "$subject_phrase|$verb_phrase|$direct_object\n"
		if $DEBUG_DETAIL;
	    my $action = '';

	    # Event Action

	    if ($verb_phrase =~ /born/) {
	        #my $qualifier = $verb_phrase =~ /was/x ? 'was' : '';
	        #Action->new({name => 'born', qualifier => $qualifier});
	        Action->new({name => 'born', qualifier => 'was'});
		$action = 'born';
	    } elsif ($verb_phrase =~ /formed/) {
		Action->new({name => 'formed', qualifier => 'was'});
		$action = 'formed';
	    } elsif ($verb_phrase =~ /happened in/) {
		Action->new({name => 'happened in'});
		$action = 'happened in';
	    } elsif ($verb_phrase =~ /happened on/) {
		Action->new({name => 'happened on'});
		$action = 'happened on';
	    } elsif ($verb_phrase =~ /was/) {
		Action->new({name => 'was'});
		$action = 'was';
	    } elsif ($verb_phrase =~ /expressed/) {
		Action->new({name => 'expressed'});
		$action = 'expressed';
	    } else {
		Action->new({name => 'began'});
		$action = 'began';
	    }

	    # Direct Object

	    #if ($direct_object =~ /^(in|on) /) {
	    # Need to deal with direct object quailfiers: on, in, to, etc.
	    # I think we need a 'time' object like 'entity' and 'action' 
	    # Time.pm would be a 'direct object' object which would be a
	    # entity object.
	    #}

	    # Entity and Event

	    Entity->new($subject_phrase);
	    Event->new( {name   => $subject_phrase, 
			 action => $action,
			 time   => $direct_object});
	} else {
	  print STDERR "I don't understand this sentence: $_\n";
	  push @{$self->{unrecognized_list}}, $_;
	}
      }
}

sub getErrorMsg { 
  my ($self) = @_;
  my $list = $self->{unrecognized_list};
  return '' if $#$list==-1;
  my ($qualifier, $s) = $#$list>1 ? ('these', 's') : ('this', '');
  return 
    "I don't understand $qualifier sentence$s:\n" .
     join (".\n", @$list).".\n";
}

sub dump {
    use Data::Dumper;
    return Data::Dumper->Dump ([$_[0]]);
}

sub tellAbout {
    my ($self) = @_;
    #my $o = 'Data4 Object';
    my $o = $sumo;
    $o;
}

1;
