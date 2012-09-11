{
  package MooX::Types::MooseLike::Test::Role;
  use Role::Tiny;
  sub foo { 'ja' };
  sub bar { 'ara' };
}
{
  package MooX::Types::MooseLike::Test::AnotherRole;
  use Role::Tiny;
  sub que { 'dius' };
  sub quoi { 'dieu' };
}
{
  package MooX::Types::MooseLike::Test;
  use strict;
  use warnings FATAL => 'all';
  use Moo;
  use MooX::Types::MooseLike::Base qw/ 
    ArrayRef Int HashRef Str ScalarRef Maybe InstanceOf ConsumerOf HasMethods 
  /;
  use MooX::Types::SetObject qw/ SetObject /;
  with (
    'MooX::Types::MooseLike::Test::Role', 
    'MooX::Types::MooseLike::Test::AnotherRole'
  );

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
  has set_object_of_ints => (
    is  => 'ro',
    isa => SetObject[Int],
    );
  has instance_of_IO_Handle => (
    is  => 'ro',
    isa => InstanceOf['IO::Handle'],
    );
  has consumer_of => (
    is  => 'ro',
    isa => ConsumerOf[
      'MooX::Types::MooseLike::Test::Role',
      'MooX::Types::MooseLike::Test::AnotherRole'
    ],
    );
  has has_methods => (
    is  => 'ro',
    isa => HasMethods['foo', 'bar'],
    );
}

package main;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;
use IO::Handle;
use Set::Object;

# ArrayRef[Int]
ok(MooX::Types::MooseLike::Test->new(an_array_of_integers => [ 6, 7, 10, -1 ]),
  'ArrayRef[Int]');
like(
  exception {
    MooX::Types::MooseLike::Test->new(an_array_of_integers => [ 1.5, 2 ]);
  },
  qr/is not an Integer/,
  'an ArrayRef of Floats is an exception when we want an ArrayRef[Int]'
  );

# ArrayRef[HashRef]
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

# HashRef[Str]
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

# ArrayRef[HashRef[Int]]
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

# ScalarRef[Int]
ok(MooX::Types::MooseLike::Test->new(a_scalar_ref_of_int => \1),
  'ScalarRef[Int]');
like(
  exception { MooX::Types::MooseLike::Test->new(a_scalar_ref_of_int => \'x') },
  qr/is not an Integer/,
  'a ScalarRef of Str is an exception when we want an ScalarRef[Int]'
  );

# ScalarRef[Int]
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

# ArrayRef[Maybe[HashRef]]
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

# ArrayRef[Maybe[HashRef[Int]]]
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

# Set::Object
ok(
  MooX::Types::MooseLike::Test->new(
    set_object_of_ints => Set::Object->new(1,2,3),
    ),
  'Set::Object of Int'
  );
like(
  exception {
    MooX::Types::MooseLike::Test->new(
      set_object_of_ints => Set::Object->new('fREW'),
      )
  },
  qr(fREW is not an Integer),
  'Int eror mesage is triggered when validation fails'
  );

# InstanceOf
ok(MooX::Types::MooseLike::Test->new(instance_of_IO_Handle => IO::Handle->new ), 'instance of IO::Handle');
my $false_instance = {};
like(
  exception {
    MooX::Types::MooseLike::Test->new(instance_of_IO_Handle => $false_instance);
  },
  qr/is not an instance of IO::Handle/,
  'a hashref is not an instance of IO::Handle'
  );

# ConsumerOf
ok(MooX::Types::MooseLike::Test->new(consumer_of => MooX::Types::MooseLike::Test->new ), 'consumer of a some roles');
my $false_consumer = IO::Handle->new;
like(
  exception {
    MooX::Types::MooseLike::Test->new(consumer_of => $false_consumer);
  },
  qr/is not a consumer of roles/,
  'an IO::Handle instance is not a consumer of roles'
  );

# HasMethods
ok(MooX::Types::MooseLike::Test->new(has_methods => MooX::Types::MooseLike::Test->new ), 'has methods of madness');
my $false_has_methods = IO::Handle->new;
like(
  exception {
    MooX::Types::MooseLike::Test->new(has_methods => $false_has_methods);
  },
  qr/does not have the required methods/,
  'an object instance does not have the required methods'
  );

done_testing;
