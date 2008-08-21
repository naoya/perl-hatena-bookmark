#!/usr/bin/env perl
use strict;
use warnings;
use FindBin::libs;

use Perl6::Say;
use Encode;
use Hatena::Bookmark;

my $url = shift or die "usage $0 <url>";
my $entry = entry($url) or die "No such entry $url";

say $entry->title;
say $entry->url->host;
say $entry->entry_url->host;
say $entry->count;
say $entry->screenshot->host;
say sprintf "%s: %s (%s)", $entry->bookmarks->[0]->user->name, $entry->bookmarks->[0]->comment, $entry->bookmarks->[0]->timestamp->ymd('/');

for (@{$entry->related}) {
    say sprintf "%s (%s)", $_->title, $_->count;
}
