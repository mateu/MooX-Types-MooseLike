use strictures 1;

package MooX::Types::MooseLike::Numeric;
use MooX::Types::MooseLike::Base;
use Exporter 5.57 'import';
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
    name       => 'PositiveOrZeroNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
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
    name       => 'PositiveOrZeroInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { $_[0] >= 0 },
    message    => sub { "$_[0] is not a non-negative integer!" },
  },
  {
    name       => 'NegativeNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { $_[0] < 0 },
    message    => sub { "$_[0] is not a negative number!" },
  },
  {
    name       => 'NegativeOrZeroNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { $_[0] <= 0 },
    message    => sub { "$_[0] is not a non-positive number!" },
  },
  {
    name       => 'NegativeInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { $_[0] < 0 },
    message    => sub { "$_[0] is not a negative integer!" },
  },
  {
    name       => 'NegativeOrZeroInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { $_[0] <= 0 },
    message    => sub { "$_[0] is not a non-positive integer!" },
  },
  {
    name       => 'SingleDigit',
    subtype_of => 'PositiveOrZeroInt',
    from       => 'MooX::Types::MooseLike::Numeric',
    test       => sub { $_[0] < 10 },
    message    => sub { "$_[0] is not a single digit!" },
  },
];

MooX::Types::MooseLike::register_types(
  $type_definitions, __PACKAGE__, 'MooseX::Types::Common::Numeric'
);
our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

1

__END__

=head1 NAME

MooX::Types::MooseLike::Numeric - Moo types for numbers

=head1 SYNOPSIS

    package MyPackage;
    use Moo;
    use MooX::Types::MooseLike::Numeric qw(PositiveInt);

    has "daily_breathes" => (
        isa => PositiveInt
    );

=head1 DESCRIPTION

adpated from MooseX::Types::Common::Numeric

=head1 TYPES (subroutines)

Available types are listed below.

=over

=item PositiveNum

=item PositiveOrZeroNum

=item PositiveInt

=item PositiveOrZeroInt

=item NegativeNum

=item NegativeOrZeroNum

=item NegativeInt

=item NegativeOrZeroInt

=item SingleDigit

=back
