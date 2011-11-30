use strictures 1;

package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use Scalar::Util qw(blessed);
use List::Util;

use base qw(Exporter);

# These types act like those found in Moose::Util::TypeConstraints.
# Generally speaking, the same test is used.
my %types = (
  Any => {
    test    => sub { 1 },
    message => sub { "If you get here you've achieved the impossible, congrats." }
    },
  Item => {
    test    => sub { 1 },
    message => sub { "If you get here you've achieved the impossible, congrats" }
    },
  Undef => {
    test    => sub { !defined($_[0]) },
    message => sub { "$_[0] is not undef" }
    },
# Note the single quotes so $_[0] is not interpreted - undef and strictures => FATAL
  Defined => {
    test    => sub { defined($_[0]) },
    message => sub { '$_[0] is not defined' }
    },
  Bool => {
    #  	test    => sub { $_[0] == 0 || $_[0] == 1 },
    test    => sub {  !defined($_[0]) || $_[0] eq "" || "$_[0]" eq '1' || "$_[0]" eq '0' },
    message => sub { "$_[0] is not a Boolean" },
    },
  Value => {
    test    => sub { !ref($_[0]) },
    message => sub { "$_[0] is not a value" }
    },
  Ref => {
    test    => sub { ref($_[0]) },
    message => sub { "$_[0] is not a reference" }
    },
  Str => {
    test    => sub { ref(\$_[0]) eq 'SCALAR' },
    message => sub { "$_[0] is not a string" }
    },
  Num => {
    test    => sub { Scalar::Util::looks_like_number($_[0]) },
    message => sub { "$_[0] is not a Number!" },
    },
  Int => {
#  	test    => sub { Scalar::Util::looks_like_number($_[0]) && ($_[0] == int $_[0]) },
    test    => sub { "$_[0]" =~ /^-?[0-9]+$/ },
    message => sub { "$_[0] is not an Integer!" },
    },
  ScalarRef  => {
    test    => sub { ref($_[0]) eq 'SCALAR' },
    message => sub { "$_[0] is not an ScalarRef!" },
    },
  ArrayRef  => {
    test    => sub { ref($_[0]) eq 'ARRAY' },
    message => sub { "$_[0] is not an ArrayRef!" },
    },
  HashRef  => {
    test    => sub { ref($_[0]) eq 'HASH' },
    message => sub { "$_[0] is not a HashRef!" },
    },
  CodeRef  => {
    test    => sub { ref($_[0]) eq 'CODE' },
    message => sub { "$_[0] is not a CodeRef!" },
    },
  RegexpRef  => {
    test    => sub { ref($_[0]) eq 'Regexp' },
    message => sub { "$_[0] is not a RegexpRef!" },
    },
  GlobRef => {
    test    => sub { ref($_[0]) eq 'GLOB' },
    message => sub { "$_[0] is not a GlobRef!" },
    },
  FileHandle  => {
    test    => sub { Scalar::Util::openhandle($_[0]) || (blessed($_[0]) && $_[0]->isa("IO::Handle")) },
    message => sub { "$_[0] is not a FileHandle!" },
    },
  Object => {
    test    => sub { blessed($_[0]) && blessed($_[0]) ne 'Regexp' },
    message => sub { "$_[0] is not an Object!" },
    },
  AHRef  => {
    test    => sub { (ref($_[0]) eq 'ARRAY')
        && ($_[0]->[0])
        && ( List::Util::first { ref($_) eq 'HASH' } @{$_[0]} )
      },
    message => sub { "$_[0] is not an ArrayRef[HashRef]!" },
    },
  );

my @types = keys %types;
# Add is_Type (test) to the exports
my @tests = map { 'is_' . $_ } @types;
our @EXPORT_OK = (@types, @tests);
our %EXPORT_TAGS = ( 'all' => \@EXPORT_OK );

foreach my $type (keys %{types}) {
  next unless (defined $types{$type}->{message});

  my $assertion = 'assert_' . $type;
  my $name = __PACKAGE__ . '::' . $assertion;
  my $msg; $$msg   = $types{$type}->{message};
  my $test; $$test = $types{$type}->{test};

  quote_sub $name => q{
        die $$msg->(@_) if not $$test->(@_);
}, { '$msg' => \$msg, '$test' => \$test };

  {
    no strict 'refs'; ## no critic
    # Construct the Type
    *$type = sub {
      __PACKAGE__->can($assertion);
      };

    # Make the type test available as: is_Type
    my $is_type = 'is_' . $type;
    *$is_type = sub {
      die "Exception: ${is_type}() can only take one argument.\nSuggestion: Maybe you want to pass a reference?\n"
        if defined $_[1];
      $$test->($_[0]);
      }
  }
}

1;

=head1 NAME

MooX::Types::MooseLike - Moose like types for Moo

=head1 SYNOPSIS

    package MyPackage;
    use Moo;
    use MooX::Types::MooseLike qw(:all);
    
    has "beers_by_day_of_week" => (
        isa => HashRef
    );
    has "current_BAC" => (
        isa => Num
    );
    
    # Also supporting is_$type.  For example, is_Int() can be used as follows
    has 'legal_age' => (
        is => 'ro',
        isa => sub { die "$_[0] is not of legal age" 
        	           unless (is_Int($_[0]) && $_[0] > 17) },
);

=head1 SUBROUTINES (Types)

=head2 Any

Any type (test is always true)

=head2 Item

Synonymous with Any type 

=head2 Undef

A type that is not defined

=head2 Defined

A type that is defined

=head2 Bool

A boolean 1|0 type

=head2 Value

A non-reference type

=head2 Ref

A reference type

=head2 Str

A non-reference type where a reference to it is a SCALAR

=head2 Num

A number type

=head2 Int

An integer type

=head2 ArrayRef

An ArrayRef (ARRAY) type

=head2 HashRef

A HashRef (HASH) type

=head2 CodeRef

A CodeRef (CODE) type

=head2 RegexpRef

A regular expression reference type

=head2 GlobRef

A glob reference type

=head2 FileHandle

A type that is either a builtin perl filehandle or an IO::Handle object

=head2 Object

A type that is an object (think blessed)

=head2 AHRef

An ArrayRef[HashRef] type

=head1 AUTHOR

Mateu Hunter C<hunter@missoula.org>

=head1 THANKS

mst provided the implementation suggestion of using 'can' on a quoted sub 
to define a type (subroutine).

=head1 COPYRIGHT

Copyright 2011, Mateu Hunter

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut
