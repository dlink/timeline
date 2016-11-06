package Data4;

use strict;
use English;

# STATIC METHODS:

my $DEBUG = 0;

my $sumo = __PACKAGE__;

#-------------------------------------------------------
# Method:  new ( filename )
# Return:  HASHREF
#-------------------------------------------------------
sub new {
    print STDERR "$sumo->new ( @_ )\n" if $DEBUG;
    my ($_type, $filename) = @_;
    my $class = ref($_type) || $_type;
    my $self = {};
    die "$sumo->new, must specify filename\n" if !$filename;
    $self->{filename} = $filename;
    bless( $self, $class); 
    $self->load_data;
    return $self;
}

sub load_data {
    my $self = shift;
    my $filename = $self->{filename};
    open F, "<$filename" or die "$! $filename\n";
    undef $/;
    my $heap = (<F>);
    close F;
    #print $heap;

    #my @sentences = map {$_ =~ s/\n*//g} split /\./, $heap;
    my @sentences0 = split /\./, $heap;
    my @sentences = ();
    for (@sentences0) {
	$_ =~ s/\n*//g;
	push @sentences, $_;
    }
    (my $last = pop @sentences) =~ s/\s*//;
    push @sentences, $last if $last;

    for (@sentences) {
	chomp;
	if (m/\b was born\s*(in|on|)/ ||
	    m/\b began \s*(in|on|)/x ||
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
		if $DEBUG;
	    my $action = '';
	    if ($verb_phrase =~ /born/) {
		Action->new({name => 'born', qualifier => 'was'});
		$action = 'born';
	    } elsif ($verb_phrase =~ /formed/) {
		Action->new({name => 'formed', qualifier => 'was'});
		$action = 'formed';
	    } elsif ($verb_phrase =~ /happened/) {
		Action->new({name => 'happened'});
		$action = 'happened';
	    } else {
		Action->new({name => 'began'});
		$action = 'began';
	    }
	    Entity->new($subject_phrase);
	    Event->new( {name   => $subject_phrase, 
			 action => $action,
			 time   => $direct_object});
	} else {
	    print STDERR "I don't understand this sentence: $_\n";
	}
    }
}

sub dump {
    use Data::Dumper;
    return Data::Dumper->Dump ([$_[0]]);
}

sub tellAbout {
    my ($self) = @_;
    my $o = 'Data4 Object';
    $o;
}

1;
