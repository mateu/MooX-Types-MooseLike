use strictures 1;
package MooX::Types::MooseLike::Numeric;
use MooX::Types::MooseLike::Base;
use base qw(Exporter);
our @EXPORT_OK = ();

my $type_definitions = [
	{
		name       => 'PositiveNum',
		subtype_of => 'Num',
		from       => 'MooX::Types::MooseLike::Base',
		test       => sub { $_[0] > 0 },
		message    => sub { "$_[0] is not a positive number!" },
	},
	{
		name       => 'NonNegativeNum',
		subtype_of => 'Num',
		test       => sub { $_[0] >= 0 },
		message    => sub { "$_[0] is not a non-negative number!" },
	},	
	{
		name       => 'PositiveInt',
		subtype_of => 'Int',
		from       => 'MooX::Types::MooseLike::Base',
		test       => sub { $_[0] > 0 },
		message    => sub { "$_[0] is not a positive integer!" },
	},
	{
		name       => 'NonNegativeInt',
		subtype_of => 'Int',
		from       => 'MooX::Types::MooseLike::Base',
		test       => sub { $_[0] >= 0 },
		message    => sub { "$_[0] is not a non-negative integer!" },
	},	
	{
		name       => 'NegativeNum',
		subtype_of => 'Num',
		test       => sub { $_[0] < 0 },
		message    => sub { "$_[0] is not a negative number!" },
	},
	{
		name       => 'NonPositiveNum',
		subtype_of => 'Num',
		test       => sub { $_[0] <= 0 },
		message    => sub { "$_[0] is not a non-positive number!" },
	},	
	{
		name       => 'NegativeInt',
		subtype_of => 'Int',
		test       => sub { $_[0] < 0 },
		message    => sub { "$_[0] is not a negative integer!" },
	},
	{
		name       => 'NonPositiveInt',
		subtype_of => 'Int',
		test       => sub { $_[0] <= 0 },
		message    => sub { "$_[0] is not a non-positive integer!" },
	},		
	{
		name       => 'SingleDigit',
		subtype_of => 'NonNegativeInt',
		from       => 'MooX::Types::MooseLike::Numeric',
		test       => sub { $_[0] < 10 },
		message    => sub { "$_[0] is not a single digit!" },
	},
];

MooX::Types::MooseLike::register_types($type_definitions, __PACKAGE__);
our %EXPORT_TAGS = ( 'all' => \@EXPORT_OK );


1