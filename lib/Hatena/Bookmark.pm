package Hatena::Bookmark;
use strict;
use warnings;
use Exporter::Lite;

our $VERSION = 0.01;
our @EXPORT = qw/entry/;

use Hatena::Bookmark::Entry;

sub entry ($) {
    my $url = shift;
    return Hatena::Bookmark::Entry->retrieve( $url );
}

1;

__END__

=head1 NAME

Hatena::Bookmark - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Hatena::Bookmark;
  blah blah blah

=head1 DESCRIPTION

Blah blah blah.

=head2 EXPORT

=head1 SEE ALSO

=head1 AUTHOR

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
