#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Getopt::Long;
use Web::Query;

use constant HAVE_HTTP_TINY  => eval q{require HTTP::Tiny; 1;};
use constant HAVE_LWP_SIMPLE => eval q{require LWP::Simple; 1;};
# TODO: Is need to support Furl?
# TODO: Is need to HTTP proxy support?

# my $p = Getopt::Long::Parser->new(
#     config => [qw(posix_default no_ignore_case auto_help)]
# );
# $p->getoptions(
#     'env-proxy!' => \my $env_proxy,
# );

my $LET_BASEURL = "http://let.hatelabo.jp";
my $LET_ID      = $ARGV[0] || "xtetsuji" ;
my $BACKUP_DIR  = $ARGV[1] || "backup";

if ( !-d $BACKUP_DIR ) {
    mkdir $BACKUP_DIR;
}

wq("$LET_BASEURL/$LET_ID/")
    ->find('div.codelist a.code-path')
    ->each(sub {
       my $i = shift;
       my $href = $_->attr('href');
       printf "backup: %2d %s\n", $i+1, $href;
       my $url_base = "$LET_BASEURL/$href";
       ( my $key = $href ) =~ s{.*/}{};
       for my $ext (qw(.js .packed.js .metadata.json)) {
           my $content = get("$url_base$ext");
           if ( $content ) {
               save("$BACKUP_DIR/$key$ext", $content );
           }
           else {
               warn "url=$url_base get error.\n";
           }
       }
     });

sub save {
    my $filename = shift;
    my $content  = shift;
    #open my $fh, '>:utf8', $filename
    open my $fh, '>', $filename
        or die;
    print {$fh} $content;
    close $fh;
}

sub get {
    my $url = shift;
    if ( HAVE_HTTP_TINY ) {
        my $response = HTTP::Tiny->new->get($url);
        return $response->{success} && $response->{content} || '';
    }
    elsif ( HAVE_LWP_SIMPLE ) {
        return LWP::Simple::get($url);
    }
}

=pod

=head1 NAME

backup.pl - backup your Hatena::Let bookmarklets

=head1 SYNOPSIS

  backup.pl $YOUR_HATENA_ID
  backup.pl $YOUR_HATENA_ID $BACKUP_DIR

Default $YOUR_HATENA_ID is "xtetsuji", and
default $BACKUP_DIR is "backup" in current directory.

=head1 REQUIRE

L<Web::Query>

Either following mode is need for HTTP GET:

L<HTTP::Tiny>, L<LWP::Simple>

=head1 AUTHOR

OGATA Tetsuji E<lt>tetsuji.ogata {at} gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
