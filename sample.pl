#!/usr/bin/perl
use strict;
use warnings;

use RadiusParser;
use LogCounter;

use Data::Dumper;

my $parser = RadiusParser->new( filename => 'radius.log' );

my $data = $parser->parse;

my $counter = LogCounter->new($data);
#print Dumper $data;
#my $data = $counter->group_by_user;

#warn Dumper $counter->group_by_user;

#print $counter->group_by_user->{'tneeds@niizuma.eduroam.jp'};

#warn Dumper $parser->parse;

my $data2 =  $counter->group_by_date;

warn Dumper $data2;


