package MooX::Types::MooseLike::Numeric;
use strict;
use warnings FATAL => 'all';
use MooX::Types::MooseLike qw(exception_message);
use MooX::Types::MooseLike::Base;
use Exporter 5.57 'import';
our @EXPORT_OK = ();

my $type_definitions = [
  {
    name       => 'PositiveNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] > 0 },
    message    => sub { return exception_message($_[0], 'a positive number') },
  },
  {
    name       => 'PositiveOrZeroNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] >= 0 },
    message    => sub { return exception_message($_[0], 'a positive number or zero') },
  },
  {
    name       => 'PositiveInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] > 0 },
    message    => sub { return exception_message($_[0], 'a positive integer') },
  },
  {
    name       => 'PositiveOrZeroInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] >= 0 },
    message    => sub { return exception_message($_[0], 'a positive integer or zero') },
  },
  {
    name       => 'NegativeNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] < 0 },
    message    => sub { return exception_message($_[0], 'a negative number') },
  },
  {
    name       => 'NegativeOrZeroNum',
    subtype_of => 'Num',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] <= 0 },
    message    => sub { return exception_message($_[0], 'a negative number or zero') },
  },
  {
    name       => 'NegativeInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] < 0 },
    message    => sub { return exception_message($_[0], 'a negative integer') },
  },
  {
    name       => 'NegativeOrZeroInt',
    subtype_of => 'Int',
    from       => 'MooX::Types::MooseLike::Base',
    test       => sub { defined $_[0] and $_[0] <= 0 },
    message    => sub { return exception_message($_[0], 'a negative integer or zero') },
  },
  {
    name       => 'SingleDigit',
    subtype_of => 'PositiveOrZeroInt',
    from       => 'MooX::Types::MooseLike::Numeric',
    test       => sub { defined $_[0] and $_[0] < 10 },
    message    => sub { return exception_message($_[0], 'a single digit') },
  },
  ];

MooX::Types::MooseLike::register_types($type_definitions, __PACKAGE__,
  'MooseX::Types::Common::Numeric');
our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

1;

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
