{
use strictures 1;
package MooX::Types::MooseLike::Numeric::Test;
use Moo;
use MooX::Types::MooseLike::Numeric qw(:all);

has 'a_positive_number' => (
    is => 'ro',
    isa => PositiveNum,
);
has 'a_nonnegative_number' => (
    is => 'ro',
    isa => NonNegativeNum,
);
has 'a_positive_integer' => (
    is => 'ro',
    isa => PositiveInt,
);
has 'a_nonnegative_integer' => (
    is => 'ro',
    isa => NonNegativeInt,
);
has 'a_negative_number' => (
    is => 'ro',
    isa => NegativeNum,
);
has 'a_nonpositive_number' => (
    is => 'ro',
    isa => NonPositiveNum,
);
has 'a_negative_integer' => (
    is => 'ro',
    isa => NegativeInt,
);
has 'a_nonpositive_integer' => (
    is => 'ro',
    isa => NonPositiveInt,
);
has 'a_single_digit' => (
    is => 'ro',
    isa => SingleDigit,
);

}
{
package main;
use strictures 1;
use Test::More;
use Test::Fatal;
use IO::Handle;
use MooX::Types::MooseLike::Numeric qw(:all);

ok( is_PositiveNum(1),            'is_PositiveNum');
ok(!is_PositiveNum(0),            'is_PositiveNum fails on zero');
ok( is_NonNegativeNum(3.142),     'is_NonNegativeNum');
ok(!is_NonNegativeNum(-1),        'is_NonNegativeNum fails on -1');
ok( is_PositiveInt(1),            'is_PositiveInt');
ok(!is_PositiveInt(0),            'is_PositiveInt fails on zero');
ok( is_NonNegativeInt(0),         'is_NonNegativeInt');
ok(!is_NonNegativeNum(-1),        'is_NonNegativeInt fails on -1');

ok( is_NegativeNum(-1),           'is_NegativeNum');
ok(!is_NegativeNum(0),            'is_NegativeNum fails on zero');
ok( is_NonPositiveNum(-3.142),    'is_NonPositiveNum');
ok(!is_NonPositiveNum(1),         'is_NonPositiveNum fails on 1');
ok( is_NegativeInt(-1),           'is_NegativeInt');
ok(!is_NegativeInt(0),            'is_NegativeInt fails on zero');
ok( is_NonPositiveInt(0),         'is_NonPositiveInt');
ok(!is_NonPositiveNum(1),         'is_NonPositiveInt fails on 1');

## PositiveNum
ok(MooX::Types::MooseLike::Numeric::Test->new(a_positive_number => 1), 'PositiveNum');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_positive_number => '') }, 
    qr/is not a positive number/,
    'empty string is an exception when we want a positive number'
);
## NonNegativeNum
ok(MooX::Types::MooseLike::Numeric::Test->new(a_nonnegative_number => 0), 'NonNegativeNum');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_nonnegative_number => -1) }, 
    qr/is not a non-negative number/,
    '-1 is an exception when we want a non-negative number'
);

## PositiveInt
ok(MooX::Types::MooseLike::Numeric::Test->new(a_positive_integer => 1), 'PositiveInt');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_positive_integer => '') }, 
    qr/is not a positive integer/,
    'empty string is an exception when we want a positive integer'
);
## NonNegativeInt
ok(MooX::Types::MooseLike::Numeric::Test->new(a_nonnegative_integer => 0), 'NonNegativeNum');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_nonnegative_integer => -1) }, 
    qr/is not a non-negative integer/,
    '-1 is an exception when we want a non-negative integer'
);


## NegativeNum
ok(MooX::Types::MooseLike::Numeric::Test->new(a_negative_number => -11), 'NegativeNum');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_negative_number => '') }, 
    qr/is not a negative number/,
    'empty string is an exception when we want a negative number'
);
## NonPositiveNum
ok(MooX::Types::MooseLike::Numeric::Test->new(a_nonpositive_number => 0), 'NonPositiveNum');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_nonpositive_number => 1) }, 
    qr/is not a non-positive number/,
    '1 is an exception when we want a non-negative number'
);

## NegativeInt
ok(MooX::Types::MooseLike::Numeric::Test->new(a_negative_integer => -1), 'NegativeInt');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_negative_integer => '') }, 
    qr/is not a negative integer/,
    'empty string is an exception when we want a negative integer'
);
## NonPositiveInt
ok(MooX::Types::MooseLike::Numeric::Test->new(a_nonpositive_integer => 0), 'NonPositiveInt');
like(
    exception { MooX::Types::MooseLike::Numeric::Test->new(a_nonpositive_integer => 1) }, 
    qr/is not a non-positive integer/,
    '1 is an exception when we want a non-negative integer'
);



done_testing;
}