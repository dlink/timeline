#!/usr/bin/perl -w
# $Id: timeline.cgi,v 1.11 2006/06/26 03:01:10 david Exp $

package TimelinePage;

use lib ('../lib');
use strict;
use Configx;
use IO::Dir;
use CGI;
use HTML::Table;
use Timeline;

my $DEBUG = 0;
my $sumo = __PACKAGE__;

sub new {
    my $self = {};
    my $q = $self->{q} = new CGI;
    $self->{debug_msg} = '';

    # State stuff
    my $livedata = '';
    my $datadesc = '';
    $self->{datafile} = $q->param('datafile') || 'universe.data';

    my $redraw_yn = $q->param('redraw_yn');
    if ($redraw_yn) {
      $livedata = $q->param('datatext');
      $datadesc = 'not_saved'
    } else {
      $datadesc = $self->{datafile};
    }
    print STDERR "$sumo->new: livedata=$livedata, datadesc=$datadesc, " .
                 "datafile=$self->{datafile}\n" if $DEBUG;
    $self->{datadesc} = $datadesc;
    $self->{timeline} = new Timeline($self->{datafile});
    $self->{timeline}->setDataText($livedata) if $livedata; # need to do better.
    return bless $self;
}

sub getWebPage {
    my ($self) = @_;
    my $q = $self->{q};
    
    print 
	$q->header,
	$q->start_html(-title => "Timeline",
		      -author => 'dlink@crowfly.net',
		      -style  => { 'src' => 'css/timeline.css'},
		      -script => { 'src' => 'js/timeline.js'},
		      -dtd    => "-//W3C//DTD HTML 4.01 Transitional//EN",
		      ),
	$self->getPageHeader,
	$self->debugMsg,
	$self->getTimelineImage,
	$self->getUserControl,
	$q->end_html,
	"\n"
	    ;
}

sub getPageHeader {
#    return qq|<font size="+1">Timeline</font><p>|;
    return qq|<div class="pageHeader">Timeline</div><p>|;
}

sub debugMsg {
  return '' if !$DEBUG;
  my ($self) = @_;
  return "DEBUG<br>$self->{debug_msg}";
  
}

sub getTimelineImage {
    my ($self) = @_;
    my $q = $self->{q};
    my $timeline = $self->{timeline};
    #return 'drawtimeline<p>';
    return $q->div({-class=>"picture"}, $q->pre("\n".$timeline->drawTimeline));
}

sub getUserControl {
    my ($self) = @_;
    my $q = $self->{q};
    my $timeline = $self->{timeline};

    # data

    my $datadesc = $self->{datadesc};
    my $data_area = '';
    $data_area .= "Timeline Data &nbsp;" .
      "<span class='filename'>$datadesc</span><br>";
    $q->param('datatext', $timeline->getData);
    $q->param('datatext_error', $timeline->getErrorMsg);
    my $datatext = $q->textarea(-name => 'datatext',
				-default => $timeline->getData,
				-rows => 10, 
				-columns => 50);
    $data_area .= $q->textarea(-name => 'datatext',
				  -default => $timeline->getData,
				  -rows => 10, 
				  -columns => 50);
    if (my $error_msg = $timeline->getErrorMsg) {
      $data_area .= "<br>";
      $data_area .= $q->textarea(-name => 'datatext_error',
				 -default => $error_msg,
				 -rows => 3, 
				 -columns => 50);
    } else {
      $data_area .= $q->hidden(-name => 'datatext_error');
    }

    $data_area .=
	"<br>" .
	"Add new sentences in data text area and click \"redraw\".<br>" .
	"You need to add a period on the end of each sentence.";

    # controls

    my $redraw = $q->button( -name    => 'redraw',
			     -onClick => 'resetdata()' );
    my $controls = '';
    my @buttons = ();
    $controls .=
      '<br>' .
      $redraw .
      '<hr>' .
      join ('<br>', 
	  $q->button(-name => 'New __', -size => 50, -disabled=>1),
	  $q->button(-name => 'Open ..', -disabled=>1),
	  $q->button(-name => 'Save __', -disabled=>1),
	  $q->button(-name => 'Save As ..', -disabled=>1));


    # Textfiles

    my $textfiles = '';
    my $c = Configx->new; my $datadir = $c->getdatadir;
    my $d = IO::Dir->new($datadir);
    my @list = ();
    if (defined($d)) {
      while (defined($_ = $d->read)) {
	next if /^CVS/  ||  /^\./  ||  /\.sav$/  ||  /~$/;
	push @list, $_;
      }
      @list = sort @list;
    } else {
      push @list, "Could not read datadir: $datadir";
    }
    $textfiles .= "Timeline Text Files &nbsp;" .
      "<span class='filename'>data</span><br>";

    $textfiles .= $q->scrolling_list (-name => 'textfiles',
				-values => [@list],
				-size=> 10,
				-multiple => 1,
				     -onClick => 'choosef()');

    my $table = HTML::Table->new;
    $table->addRow ($data_area, $controls, $textfiles);
    $table->setColVAlign(2, 'top');
    $table->setColVAlign(3, 'top');

    my $h = '';
    $h .= $q->hidden(-name => 'datafile');
    $h .= $q->hidden(-name => 'redraw_yn');

    return 
      $q->start_form (-name=>'controls') .
      $table .
      $h .
      $q->end_form .
      "\n";
}

# main

my $timeline = new TimelinePage ('family.data');
$timeline->getWebPage;

