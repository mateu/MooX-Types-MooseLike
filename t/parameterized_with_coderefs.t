{
  package MooX::Types::MooseLike::Test;
  use strict;
  use warnings FATAL => 'all';
  use Moo;
  use MooX::Types::MooseLike::Base qw/ AnyOf Object Int ArrayRef HashRef /;

  has any_of => (
    is  => 'ro',
    isa => AnyOf[Int, ArrayRef[Int], HashRef[Int], Object],
    );
}
package main;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;
use IO::Handle;

# AnyOf
ok(MooX::Types::MooseLike::Test->new(any_of => IO::Handle->new ), 'value is AnyOf[Int, ArrayRef[Int], HashRef[Int], Object]');
ok(MooX::Types::MooseLike::Test->new(any_of =>  108  ), 'Int is AnyOf[Int, ArrayRef[Int], HashRef[Int], Object]');
ok(MooX::Types::MooseLike::Test->new(any_of => [108] ), 'ArrayRef[Int] is AnyOf[Int, ArrayRef[Int], HashRef[Int], Object]');
ok(MooX::Types::MooseLike::Test->new(any_of => {auspicious_number => 108} ), 'HashRef[Int] is AnyOf[Int, ArrayRef[Int], HashRef[Int], Object]');
my $false_value;
like(
  exception {
    MooX::Types::MooseLike::Test->new(any_of => $false_value);
  },
  qr/is not any of/,
  'undef is not an any of the types given"'
  );
$false_value = 'peace_treaty';
like(
  exception {
    MooX::Types::MooseLike::Test->new(any_of => $false_value);
  },
  qr/is not any of/,
  'a string is not any of the types given'
  );

done_testing;