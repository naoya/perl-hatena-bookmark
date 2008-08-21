package Hatena::Bookmark::Entry;
use Moose;
use Moose::Util::TypeConstraints;

use Encode;
use Encode::JavaScript::UCS;
use JSON::Syck;
use LWP::UserAgent;
use Params::Validate qw/validate_pos/;

use Hatena::Bookmark::Bookmark;

subtype 'UTF8'
    => as 'Str';

coerce 'UTF8'
    => from 'Str'
    => via { decode('JavaScript-UCS', $_) };

subtype 'URI',
    => as 'Object'
    => where { $_->isa('URI') };

coerce 'URI',
    => from 'Str'
    => via { URI->new($_) };

subtype 'ArrayRef[Bookmark]'
    => as 'ArrayRef';

coerce 'ArrayRef[Bookmark]'
    => from 'ArrayRef[HashRef]'
    => via { [ map { Hatena::Bookmark::Bookmark->new(%$_) } @$_ ] };

subtype 'ArrayRef[Entry]'
    => as 'ArrayRef';

coerce 'ArrayRef[Entry]'
    => from 'ArrayRef[Entry]'
    => via { [ map { Hatena::Bookmark::Entry->new(%$_) } @$_ ] };

has 'title' => (
    is       => 'ro',
    isa      => 'UTF8',
    required => 1,
    coerce   => 1,
);

has 'url' => (
    is       => 'rw',
    isa      => 'URI',
    required => 1,
    coerce   => 1,
);

has 'entry_url' => (
    is       => 'rw',
    isa      => 'URI',
    required => 1,
    coerce   => 1,
);

has 'count' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    default  => 0,
);

has 'screenshot' => (
    is     => 'ro',
    isa    => 'URI',
    coerce => 1,
);

has 'related' => (
    is => 'rw',
);

has 'bookmarks' => (
    is     => 'ro',
    isa    => 'ArrayRef[Bookmark]',
    coerce => 1,
);

has 'related' => (
    is     => 'ro',
    isa    => 'ArrayRef[Entry]',
    coerce => 1,
);

sub retrieve {
    my ($class, $url) = validate_pos(@_, 1, 1);

    my $api = URI->new('http://b.hatena.ne.jp/entry/json/');
    $api->query_form( url => $url );

    my $ua = LWP::UserAgent->new;
    $ua->agent(sprintf "perl-Hatena-Bookmark/%s", Hatena::Bookmark->VERSION);
    $ua->timeout(10);

    my $res = $ua->get($api);
    die $res->status_line if $res->is_error;

    ## hmm..
    my $json = $res->content;
    $json =~ s/^\(//;
    $json =~ s/\)$//;

    my $data = JSON::Syck::Load( $json ) or return;
    $class->new( %$data );
}

1;

