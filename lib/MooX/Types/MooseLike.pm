use strictures 1;
package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use Scalar::Util;
use List::Util;

use base qw(Exporter);
our @EXPORT = qw(ArrayRef);

=head1 Methods

=head2 ArrayRef

An ArrayRef type

=cut

quote_sub 'MooX::Types::MooseLike::is_ArrayRef' => q{ die "$_[0] is not an ArrayRef!" if ref($_[0]) ne 'ARRAY' };

sub ArrayRef {  
    __PACKAGE__->can('is_ArrayRef');
}


1;
