use strictures 1;

package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use Scalar::Util;
use List::Util;

use base qw(Exporter);
our @EXPORT_OK = qw(
  Num Int Bool ArrayRef HashRef CodeRef RegexpRef GlobRef AHRef NoRef
);
our %EXPORT_TAGS = ( 'all' => \@EXPORT_OK );

quote_sub 'MooX::Types::MooseLike::assert_Num' => q{
        die "$_[0] is not a Number!" 
          unless Scalar::Util::looks_like_number($_[0]);
};

sub Num {
    __PACKAGE__->can('assert_Num');
}

quote_sub 'MooX::Types::MooseLike::assert_Int' => q{
        die "$_[0] is not an Integer!" 
          unless ((Scalar::Util::looks_like_number($_[0])) && ($_[0] == int $_[0]));
};

sub Int {
    __PACKAGE__->can('assert_Int');
}

quote_sub 'MooX::Types::MooseLike::assert_Bool' => q{
        die "$_[0] is not a Boolean" if ($_[0] != 0 && $_[0] != 1);
};

sub Bool {
    __PACKAGE__->can('assert_Bool');
}

quote_sub 'MooX::Types::MooseLike::assert_ArrayRef' =>
  q{ die "$_[0] is not an ArrayRef!" if ref($_[0]) ne 'ARRAY' };

sub ArrayRef {
    __PACKAGE__->can('assert_ArrayRef');
}

quote_sub 'MooX::Types::MooseLike::assert_HashRef' =>
  q{ die "$_[0] is not a HashRef!" if ref($_[0]) ne 'HASH' };

sub HashRef {
    __PACKAGE__->can('assert_HashRef');
}

quote_sub 'MooX::Types::MooseLike::assert_CodeRef' =>
  q{ die "$_[0] is not a CodeRef!" if ref($_[0]) ne 'CODE' };

sub CodeRef {
    __PACKAGE__->can('assert_CodeRef');
}

quote_sub 'MooX::Types::MooseLike::assert_RegexpRef' =>
  q{ die "$_[0] is not a RegexpRef!" if ref($_[0]) ne 'Regexp' };

sub RegexpRef {
    __PACKAGE__->can('assert_RegexpRef');
}

quote_sub 'MooX::Types::MooseLike::assert_GlobRef' =>
  q{ die "$_[0] is not a GlobRef!" if ref($_[0]) ne 'GLOB' };

sub GlobRef {
    __PACKAGE__->can('assert_GlobRef');
}

quote_sub 'MooX::Types::MooseLike::assert_AHRef' => q{
    die "$_[0] is not an ArrayRef[HashRef]!"
      if ( (ref($_[0]) ne 'ARRAY') 
           || (!$_[0]->[0]) 
           || ( List::Util::first { ref($_) ne 'HASH' } @{$_[0]} )
      );
};

sub AHRef {
    __PACKAGE__->can('assert_AHRef');
}

quote_sub 'MooX::Types::MooseLike::assert_NoRef' => q{
        die "$_[0] is a reference" if ref($_[0])
};

sub NoRef {
    __PACKAGE__->can('assert_NoRef');
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

=head1 SUBROUTINES (Types)

=head2 Num

A number type

=head2 Int

An integer type

=head2 Bool

A boolean 1|0 type

=head2 ArrayRef

An ArrayRef type

=head2 HashRef

A HashRef type

=head2 CodeRef

A CodeRef type

=head2 RegexpRef

A regular expression reference type

=head2 GlobRef

A glob reference type

=head2 AHRef

An ArrayRef[HashRef] type

=head2 NoRef

A non-reference type

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
