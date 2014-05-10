#!/usr/bin/env perl
# charset=UTF-8
# debuglet.rb の Perl 移植版 (debuglet.pl is port of debuglet.rb)
#   http://let.hatelabo.jp/xtetsuji/debuglet.rb
#   https://github.com/m4i/config/blob/master/bin/debuglet.rb
# at 2013/05/29 by xtetsuji
# at 2014/05/10 by xtetsuji
#
# TODO:
#  新しいPerlのコアモジュールだけでできるようにしたい LWP → HTTP::Tiny

use strict;
use warnings;
use utf8;

use constant ENDPOINT_URL => 'http://let.hatelabo.jp/api/';

use File::Slurp qw(read_file);
use LWP::UserAgent;

my $api_key = $ENV{DEBUGLET_API_KEY};

if ( !$api_key ) {
    die "you need API KEY for giving \"DEBUGLET_API_KEY\" environment.";
}

our $VERSION = '0.01';

my $ua = LWP::UserAgent->new( agent => "debug.et.pl/$VERSION" );

my $api_uri = 'http://let.hatelabo.jp/api/code.save';
my %options = ( api_key => $api_key );

if ( @ARGV > 0 ) {
    my $api_uri = ENDPOINT_URL . 'code.save';
    $options{source} = read_file(shift @ARGV);
    my $req = $ua->post($api_uri, \%options);
} else {
    my $api_uri = ENDPOINT_URL . 'code';
    my $req = $ua->post($api_uri, \%options);
    if ( $req->is_success ) {
        ( my $content = $req->content ) =~ s/\r\n/\n/g;
        print "$content\n";
    } else {
        print "request failed:\n" . $req->as_string;
    }
}
