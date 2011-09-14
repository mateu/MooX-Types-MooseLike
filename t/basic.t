package MooX::Types::MooseLike::Test;
use Moo;
use MooX::Types::MooseLike;

has 'an_array' => (
    is => 'ro',
    isa => ArrayRef,
);

package main;
use strictures 1;
use Test::More;
use Test::Fatal;
ok(MooX::Types::MooseLike::Test->new(an_array => []), 'ArrayRef');
like(
    exception { MooX::Types::MooseLike::Test->new(an_array => {}) }, 
    qr/HASH.*?is not an ArrayRef/,
    'a HashRef is an exception when we want an ArrayRef'
);
like(
    exception { MooX::Types::MooseLike::Test->new(an_array => 'string') }, 
    qr/string is not an ArrayRef/,
    'a String is an exception when we want an ArrayRef'
);

done_testing;