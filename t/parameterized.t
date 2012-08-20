{
  package MooX::Types::MooseLike::Test::Types;

  use Test::More;
  use MooX::Types::MooseLike::Base;
  use base qw(Exporter);
  our @EXPORT_OK = ();

# Define some types
  my $defs = [
      {
          name    => 'ScalarParamType',
          test    => sub {
            my ($value, @params) = @_;
            is(scalar @params, 2, 'correct params passed to test sub');
            is($params[0], 'param1', 'ScalarParam first param passed correctly to test()');
            is($params[1], 'param2', 'ScalarParam second param passed correctly to test()');

            return $value;
          },
          message => sub {
            my ($value, @params) = @_;
            is(scalar @params, 2, 'correct params passed to message sub');
            is($params[0], 'param1', 'ScalarParam first param passed correctly to message()');
            is($params[1], 'param2', 'ScalarParm second param passed correctly to message()');

            return "Error message";
          }
      }
  ];

# Make the types available
  MooX::Types::MooseLike::register_types($defs, __PACKAGE__);

  1;
}

{
  package MooX::Types::MooseLike::Test;
  use strict;
  use warnings FATAL => 'all';
  use Moo;
  use MooX::Types::MooseLike::Base qw/ ArrayRef Int HashRef Str ScalarRef Maybe /;
  MooX::Types::MooseLike::Test::Types->import(qw/ScalarParamType/);

  has an_array_of_integers => (
    is  => 'ro',
    isa => ArrayRef [Int],
  );
  has an_array_of_hash => (
    is  => 'ro',
    isa => ArrayRef [HashRef],
  );
  has a_hash_of_strings => (
    is  => 'ro',
    isa => HashRef [Str],
  );
  has an_array_of_hash_of_int => (
    is  => 'ro',
    isa => ArrayRef [ HashRef [Int] ],
  );
  has a_scalar_ref_of_int => (
    is  => 'ro',
    isa => ScalarRef [Int],
  );
  has maybe_an_int => (
    is  => 'ro',
    isa => Maybe [Int],
  );
  has array_maybe_a_hash => (
    is  => 'ro',
    isa => ArrayRef [ Maybe [HashRef] ],
  );
  has array_maybe_a_hash_of_int => (
    is  => 'ro',
    isa => ArrayRef [ Maybe [ HashRef [Int] ] ],
  );
  has 'scalar_param_passed_to_type' => (
    is  => 'ro',
    isa => ScalarParamType('param1', 'param2')
  );

}

package main;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;

# Test ArrayRef[Int]
ok(MooX::Types::MooseLike::Test->new(an_array_of_integers => [ 6, 7, 10, -1 ]),
  'ArrayRef[Int]');
like(
  exception {
    MooX::Types::MooseLike::Test->new(an_array_of_integers => [ 1.5, 2 ]);
  },
  qr/is not an Integer/,
  'an ArrayRef of Floats is an exception when we want an ArrayRef[Int]'
);

# Test ArrayRef[HashRef]
ok(
  MooX::Types::MooseLike::Test->new(
    an_array_of_hash => [ { a => 1 }, { b => 2 } ]
  ),
  'ArrayRef[HashRef]'
);
ok(
  MooX::Types::MooseLike::Test->new(
    an_array_of_hash => [ { a => 1 }, { b => undef } ]
  ),
  'ArrayRef[HashRef] with undef'
);
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      an_array_of_hash => [ { x => 1 }, [ 1, 2, 3 ] ]);
  },
  qr/is not a HashRef/,
  'an ArrayRef of Integers is an exception when we want an ArrayRef[HashRef]'
);

# Test HashRef[Str]
ok(MooX::Types::MooseLike::Test->new(a_hash_of_strings => { a => 1, b => 'x' }),
  'HashRef[Str]');
like(
  exception {
    MooX::Types::MooseLike::Test->new(a_hash_of_strings =>
        { a => MooX::Types::MooseLike::Test->new(), b => 'x' });
  },
  qr/is not a string/,
  'an HashRef with Objects is an exception when we want an HashRef[Str]'
);

# Test ArrayRef[HashRef[Int]]
ok(
  MooX::Types::MooseLike::Test->new(
    an_array_of_hash_of_int => [ { a => 1 }, { b => 2 } ]
  ),
  'ArrayRef[HashRef[Int]]'
);
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      an_array_of_hash_of_int => [ { x => 1 }, { x => 1.1 } ]);
  },
  qr/is not an Integer/,
'an ArrayRef of HashRef of Floats is an exception when we want an ArrayRef[HashRef[Int]]'
);

# Test ScalarRef[Int]
ok(MooX::Types::MooseLike::Test->new(a_scalar_ref_of_int => \1),
  'ScalarRef[Int]');
like(
  exception { MooX::Types::MooseLike::Test->new(a_scalar_ref_of_int => \'x') },
  qr/is not an Integer/,
  'a ScalarRef of Str is an exception when we want an ScalarRef[Int]'
);

# Test ScalarRef[Int]
ok(MooX::Types::MooseLike::Test->new(maybe_an_int => 41),
  'Maybe[Int] as an integer');
ok(MooX::Types::MooseLike::Test->new(maybe_an_int => undef),
  'Maybe[Int] as undef');
ok(MooX::Types::MooseLike::Test->new(maybe_an_int => -24),
  'Maybe[Int] as undef');
like(
  exception { MooX::Types::MooseLike::Test->new(maybe_an_int => 'x') },
  qr/is not an Integer/,
  'a Str is an exception when we want a Maybe[Int]'
);

# Test ArrayRef[Maybe[HashRef]]
ok(MooX::Types::MooseLike::Test->new(array_maybe_a_hash => [ { a => 41 } ]),
  'ArrayRef[Maybe[HashRef]] as an HashRef');
ok(
  MooX::Types::MooseLike::Test->new(
    array_maybe_a_hash => [ undef, { a => 41 } ]
  ),
  'ArrayRef[Maybe[HashRef]] with an undef'
);
like(
  exception { MooX::Types::MooseLike::Test->new(array_maybe_a_hash => ['x']) },
  qr/is not a HashRef/,
  'a Str is an exception when we want a Maybe[HashRef]'
);

# Test ArrayRef[Maybe[HashRef[Int]]]
ok(
  MooX::Types::MooseLike::Test->new(
    array_maybe_a_hash_of_int => [ { a => 41 } ]
  ),
  'ArrayRef[Maybe[HashRef]] as a HashRef[Int]'
);
ok(
  MooX::Types::MooseLike::Test->new(
    array_maybe_a_hash_of_int => [ undef, { a => -1 } ]
  ),
  'ArrayRef[Maybe[HashRef]] with an undef'
);
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      array_maybe_a_hash_of_int => [ { b => 'x' } ]);
  },
  qr/is not an Int/,
  'a Str is an exception when we want a Maybe[HashRef[Int]]'
);

ok(
  MooX::Types::MooseLike::Test->new(
    scalar_param_passed_to_type  => 1
  ),
  'scalar_param_passed_to_type validated with true value'
);
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      scalar_param_passed_to_type  => 0);
  },
  qr/Error message/,
  'scalarParam eror mesage is triggered when validation fails'
);


done_testing;
