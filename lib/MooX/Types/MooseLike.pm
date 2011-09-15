use strictures 1;

package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use Scalar::Util;
use List::Util;

use base qw(Exporter);
our @EXPORT =
  qw(Num Int ArrayRef HashRef CodeRef RegexpRef GlobRef AHRef NoRef Bool);

=head1 Methods

=head2 Num

A number type

=cut

quote_sub 'MooX::Types::MooseLike::is_Num' => q{
        die "$_[0] is not a Number!" unless Scalar::Util::looks_like_number($_[0]);
};

sub Num {
    __PACKAGE__->can('is_Num');
}

=head2 Int

An integer type

=cut

quote_sub 'MooX::Types::MooseLike::is_Int' => q{
        die "$_[0] is not an Integer!" unless ((Scalar::Util::looks_like_number($_[0])) && ($_[0] == int $_[0]));
};

sub Int {
    __PACKAGE__->can('is_Int');
}

=head2 ArrayRef

An ArrayRef type

=cut

quote_sub 'MooX::Types::MooseLike::is_ArrayRef' =>
  q{ die "$_[0] is not an ArrayRef!" if ref($_[0]) ne 'ARRAY' };

sub ArrayRef {
    __PACKAGE__->can('is_ArrayRef');
}

=head2 HashRef

A HashRef type

=cut

quote_sub 'MooX::Types::MooseLike::is_HashRef' =>
  q{ die "$_[0] is not a HashRef!" if ref($_[0]) ne 'HASH' };

sub HashRef {
    __PACKAGE__->can('is_HashRef');
}

=head2 CodeRef

A CodeRef type

=cut

quote_sub 'MooX::Types::MooseLike::is_CodeRef' =>
  q{ die "$_[0] is not a CodeRef!" if ref($_[0]) ne 'CODE' };

sub CodeRef {
    __PACKAGE__->can('is_CodeRef');
}

=head2 RegexpRef

A regular expression reference type

=cut

quote_sub 'MooX::Types::MooseLike::is_RegexpRef' =>
  q{ die "$_[0] is not a RegexpRef!" if ref($_[0]) ne 'Regexp' };

sub RegexpRef {
    __PACKAGE__->can('is_RegexpRef');
}

=head2 GlobRef

A glob reference type

=cut

quote_sub 'MooX::Types::MooseLike::is_GlobRef' =>
  q{ die "$_[0] is not a GlobRef!" if ref($_[0]) ne 'GLOB' };

sub GlobRef {
    __PACKAGE__->can('is_GlobRef');
}

=head2 AHRef

An ArrayRef[HashRef] type

=cut

quote_sub 'MooX::Types::MooseLike::is_AHRef' => q{
    die "$_[0] is not an ArrayRef[HashRef]!"
      if ( (ref($_[0]) ne 'ARRAY') || (!$_[0]->[0]) || ( List::Util::first { ref($_) ne 'HASH' } @{$_[0]} ) )
};

sub AHRef {
    __PACKAGE__->can('is_AHRef');
}

=head2 NoRef

A non-reference type

=cut

quote_sub 'MooX::Types::MooseLike::is_NoRef' => q{
        die "$_[0] is a reference" if ref($_[0])
};

sub NoRef {
    __PACKAGE__->can('is_NoRef');
}

=head2 Bool

A boolean 1|0 type

=cut

quote_sub 'MooX::Types::MooseLike::is_Bool' => q{
        die "$_[0] is not a Boolean" if ($_[0] != 0 && $_[0] != 1);
};

sub Bool {
    __PACKAGE__->can('is_Bool');
}

1;
