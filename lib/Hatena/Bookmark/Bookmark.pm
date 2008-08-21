package Hatena::Bookmark::Bookmark;
use Moose;
use Moose::Util::TypeConstraints;

use Encode qw/decode/;
use DateTime;
use DateTime::Format::Strptime;

use Hatena::Bookmark::User;

## It should be integrated by MooseX::Types but it does not work well.
subtype 'UTF8s'
    => as 'Str';

coerce 'UTF8s'
    => from 'Str'
    => via { decode('JavaScript-UCS', $_) };

subtype 'User'
    => as 'Object'
    => where { $_->isa('Hatena::Bookmark::User') };

coerce 'User'
    => from 'Str'
    => via { Hatena::Bookmark::User->new(name => $_)};

subtype 'DateTime'
    => as 'Object'
    => where { $_->isa('DateTime') };

my $strp = DateTime::Format::Strptime->new(
    pattern   => '%Y/%m/%d %T',
    time_zone => 'Asia/Tokyo',
);

coerce 'DateTime'
    => from 'Str'
    => via { $strp->parse_datetime( $_ ) };

has 'user' => (
    is     => 'ro',
    isa    => 'User',
    coerce => 1,
);

has 'comment' => (
    is     => 'ro',
    isa    => 'UTF8s',
    coerce => 1,
);

has 'timestamp' => (
    is     => 'ro',
    isa    => 'DateTime',
    coerce => 1,
);

has 'tags' => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
);

1;
