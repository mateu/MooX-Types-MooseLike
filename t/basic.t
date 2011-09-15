package MooX::Types::MooseLike::Test;
use Moo;
use MooX::Types::MooseLike qw(:all);

has 'a_number' => (
    is => 'ro',
    isa => Num,
);
has 'an_integer' => (
    is => 'ro',
    isa => Int,
);
has 'an_array' => (
    is => 'ro',
    isa => ArrayRef,
);
has 'a_hash' => (
    is => 'ro',
    isa => HashRef,
);
has 'a_code' => (
    is => 'ro',
    isa => CodeRef,
);
has 'a_regex' => (
    is => 'ro',
    isa => RegexpRef,
);
has 'a_glob' => (
    is => 'ro',
    isa => GlobRef,
);
has 'a_ahref' => (
    is => 'ro',
    isa => AHRef,
);
has 'a_noref' => (
    is => 'ro',
    isa => NoRef,
);
has 'a_bool' => (
    is => 'ro',
    isa => Bool,
);

package main;
use strictures 1;
use Test::More;
use Test::Fatal;

# Test Num
ok(MooX::Types::MooseLike::Test->new(a_number => 3.14), 'Num');
like(
    exception { MooX::Types::MooseLike::Test->new(a_number => '5x5') }, 
    qr/is not a Number/,
    'a non number is an exception when we want a Number'
);

# Test Num
ok(MooX::Types::MooseLike::Test->new(an_integer => -1), 'Int');
like(
    exception { MooX::Types::MooseLike::Test->new(an_integer => 1.01) }, 
    qr/is not an Integer/,
    'a non-integer is an exception when we want an Integer'
);

# Test ArrayRef
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

# Test HashRef
ok(MooX::Types::MooseLike::Test->new(a_hash => {}), 'HashRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_hash => []) }, 
    qr/ARRAY.*?is not a HashRef/,
    'an ArrayRef is an exception when we want a HashRef'
);
like(
    exception { MooX::Types::MooseLike::Test->new(a_hash => 'string') }, 
    qr/string is not a HashRef/,
    'a String is an exception when we want a HashRef'
);

# Test CodeRef
ok(MooX::Types::MooseLike::Test->new(a_code => sub {}), 'CodeRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_code => []) }, 
    qr/ARRAY.*?is not a CodeRef/,
    'an ArrayRef is an exception when we want a CodeRef'
);

# Test RegexpRef
ok(MooX::Types::MooseLike::Test->new(a_regex => qr{}), 'RegexpRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_regex => []) }, 
    qr/ARRAY.*?is not a RegexpRef/,
    'an ArrayRef is an exception when we want a RegexpRef'
);

# Test GlobRef
# avoid warning for using FOO only once
no warnings 'once';
ok(MooX::Types::MooseLike::Test->new(a_glob => \*FOO), 'GlobRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_glob => []) }, 
    qr/ARRAY.*?is not a GlobRef/,
    'an ArrayRef is an exception when we want a GlobRef'
);

# Test AHRef
ok(MooX::Types::MooseLike::Test->new(a_ahref => [{}]), 'AHRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_ahref => []) }, 
    qr/ARRAY.*?is not an ArrayRef\[HashRef\]/,
    'an ArrayRef is an exception when we want an AHRef'
);

# Test NoRef
ok(MooX::Types::MooseLike::Test->new(a_noref => 'yarn'), 'NoRef');
like(
    exception { MooX::Types::MooseLike::Test->new(a_noref => []) }, 
    qr/ARRAY.*?is a reference/,
    'an ArrayRef is an exception when we want a NoRef'
);

# Test Bool
ok(MooX::Types::MooseLike::Test->new(a_bool => 0), 'Bool');
my $false_boolean_value = 0.001;
like(
    exception { MooX::Types::MooseLike::Test->new(a_bool => $false_boolean_value) }, 
    qr/$false_boolean_value is not a Boolean/,
    'an non-boolean is an exception when we want a Bool'
);

done_testing;