{

  package MooX::Types::MooseLike::Test;
  use strict;
  use warnings FATAL => 'all';
  use Moo;
  use MooX::Types::MooseLike::Base qw/ Int /;
  use MooX::Types::SetObject qw/ SetObject /;

  has set_object_of_ints => (
    is  => 'ro',
    isa => SetObject[Int],
    );
}

package main;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;

BEGIN {
  eval { require Set::Object };
  plan skip_all => 'SetObject tests need Set::Object'
    if $@;
}

# Set::Object
ok(
  MooX::Types::MooseLike::Test->new(
    set_object_of_ints => Set::Object->new(1, 2, 3),
    ),
  'Set::Object of integers'
  );
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      set_object_of_ints => Set::Object->new('fREW'),);
  },
  qr(fREW is not an integer),
  'Int eror mesage is triggered when validation fails'
  );

done_testing;
