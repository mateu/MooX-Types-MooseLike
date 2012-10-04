use strict;
use warnings FATAL => 'all';
use Test::More;
use MooX::Types::MooseLike;
use MooX::Types::MooseLike::Base;

is($MooX::Types::MooseLike::Base::VERSION, $MooX::Types::MooseLike::VERSION, 'versions are equal');

done_testing;
