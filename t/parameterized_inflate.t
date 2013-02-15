use strict;
use warnings;
use Test::More;
use Test::Fatal;

eval q{
	package Local::TestClass;
	use Moo;
	use MooX::Types::MooseLike::Base 'Enum';
	has chipmunk => (is => 'ro', isa => Enum[qw(Alvin Simon Theodore)]);
	1;
} or die $@;

is(
	exception { Local::TestClass->new(chipmunk => 'Simon') },
	undef,
	'value which should not violate type constraint',
);

like(
	exception { Local::TestClass->new(chipmunk => 'Romeo') },
	qr{^isa check for "chipmunk" failed: Romeo is not any of the possible values},
	'value which should violate type constraint',
);

eval q{ require Moose } or do {
	note "Moose not available; skipping actual inflation tests";
	done_testing;
	exit;
};

my $tc = do {
	$SIG{__WARN__} = sub { 0 };
	Local::TestClass->meta->get_attribute('chipmunk')->type_constraint;
};

is(
	exception { Local::TestClass->new(chipmunk => 'Simon') },
	undef,
	'Moose loaded; value which should not violate type constraint',
);

like(
	exception { Local::TestClass->new(chipmunk => 'Romeo') },
	qr{^isa check for "chipmunk" failed: Romeo is not any of the possible values},
	'Moose loaded; value which should violate type constraint',
);

isa_ok($tc, 'Moose::Meta::TypeConstraint::Enum');
is_deeply($tc->values, [qw/Alvin Simon Theodore/], '$tc->values');

done_testing;
