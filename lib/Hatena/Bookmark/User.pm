package Hatena::Bookmark::User;
use Moose;

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

1;

