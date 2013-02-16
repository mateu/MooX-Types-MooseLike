use strict;
use warnings;
use Test::More;
use Test::Fatal;

eval q{
	package Local::TestClass;
	use Moo;
	use MooX::Types::MooseLike::Base qw( Enum AnyOf Str ArrayRef );
	has chipmunk => (is => 'ro', isa => Enum[qw(Alvin Simon Theodore)]);
	has songs    => (is => 'ro', isa => AnyOf[ Str, ArrayRef[Str] ]);
	1;
} or die $@;

is(
	exception { Local::TestClass->new(chipmunk => 'Simon', songs => []) },
	undef,
	'values which should not violate type constraints',
);

like(
	exception { Local::TestClass->new(chipmunk => 'Romeo') },
	qr{^isa check for "chipmunk" failed: Romeo is not any of the possible values},
	'value which should violate Enum type constraint',
);

like(
	exception { Local::TestClass->new(songs => {}) },
	qr{^isa check for "songs" failed: HASH\(.+?\) is not any of the types},
	'value which should violate AnyOf type constraint',
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

my $tc2 = do {
	$SIG{__WARN__} = sub { 0 };
	Local::TestClass->meta->get_attribute('songs')->type_constraint;
};

note explain($tc2);

done_testing;
