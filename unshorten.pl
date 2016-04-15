#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use feature qw(say);

my $ua = LWP::UserAgent->new;

for (@ARGV) {
    my $req = HTTP::Request->new(GET => $_);
    my $res = $ua->request($req);

    if ($res->is_success && $res->previous) {
        say $req->url, ": ", $res->request->uri;
    } else {
        say $req->url, " not redirected (", $res->status_line, ")";
    }
}

