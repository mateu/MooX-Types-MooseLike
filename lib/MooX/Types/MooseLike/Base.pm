use strictures 1;
package MooX::Types::MooseLike::Base;
use Scalar::Util qw(blessed);
use List::Util;
use MooX::Types::MooseLike;
use base qw(Exporter);
our @EXPORT_OK = ();

# These types act like those found in Moose::Util::TypeConstraints.
# Generally speaking, the same test is used.
my $type_definitions = [
  {
  	name => 'Any',
    test    => sub { 1 },
    message => sub { "If you get here you've achieved the impossible, congrats." }
  },
  {
  	name => 'Item',
    test    => sub { 1 },
    message => sub { "If you get here you've achieved the impossible, congrats" }
  },
  {
  	name => 'Undef',
    test    => sub { !defined($_[0]) },
    message => sub { "$_[0] is not undef" }
  },
# Note the single quotes so $_[0] is not interpreted because undef and strictures => FATAL
  {
  	name => 'Defined',
    test    => sub { defined($_[0]) },
    message => sub { '$_[0] is not defined' }
  },
  {
  	name => 'Bool',
    #  	test    => sub { $_[0] == 0 || $_[0] == 1 },
    test    => sub {  !defined($_[0]) || $_[0] eq "" || "$_[0]" eq '1' || "$_[0]" eq '0' },
    message => sub { "$_[0] is not a Boolean" },
  },
  {
  	name => 'Value',
    test    => sub { !ref($_[0]) },
    message => sub { "$_[0] is not a value" }
  },
  {
  	name => 'Ref',
    test    => sub { ref($_[0]) },
    message => sub { "$_[0] is not a reference" }
  },
  {
  	name => 'Str',
    test    => sub { ref(\$_[0]) eq 'SCALAR' },
    message => sub { "$_[0] is not a string" }
  },
  {
  	name => 'Num',
    test    => sub { Scalar::Util::looks_like_number($_[0]) },
    message => sub { "$_[0] is not a Number!" },
  },
  {
  	name => 'Int',
#  	test    => sub { Scalar::Util::looks_like_number($_[0]) && ($_[0] == int $_[0]) },
    test    => sub { "$_[0]" =~ /^-?[0-9]+$/ },
    message => sub { "$_[0] is not an Integer!" },
  },
  {
  	name => 'ScalarRef',
    test    => sub { ref($_[0]) eq 'SCALAR' },
    message => sub { "$_[0] is not an ScalarRef!" },
  },
  {
  	name => 'ArrayRef',
    test    => sub { ref($_[0]) eq 'ARRAY' },
    message => sub { "$_[0] is not an ArrayRef!" },
  },
  {
  	name => 'HashRef',
    test    => sub { ref($_[0]) eq 'HASH' },
    message => sub { "$_[0] is not a HashRef!" },
  },
  {
  	name => 'CodeRef',
    test    => sub { ref($_[0]) eq 'CODE' },
    message => sub { "$_[0] is not a CodeRef!" },
  },
  {
  	name => 'RegexpRef',
    test    => sub { ref($_[0]) eq 'Regexp' },
    message => sub { "$_[0] is not a RegexpRef!" },
  },
  { 
  	name => 'GlobRef', 
    test    => sub { ref($_[0]) eq 'GLOB' },
    message => sub { "$_[0] is not a GlobRef!" },
  },
  {
  	name => 'FileHandle',
    test    => sub { Scalar::Util::openhandle($_[0]) || (blessed($_[0]) && $_[0]->isa("IO::Handle")) },
    message => sub { "$_[0] is not a FileHandle!" },
  },
  {
  	name => 'Object',
    test    => sub { blessed($_[0]) && blessed($_[0]) ne 'Regexp' },
    message => sub { "$_[0] is not an Object!" },
  },
  {
  	name => 'AHRef',
    test    => sub { (ref($_[0]) eq 'ARRAY')
        && ($_[0]->[0])
        && ( List::Util::first { ref($_) eq 'HASH' } @{$_[0]} )
      },
    message => sub { "$_[0] is not an ArrayRef[HashRef]!" },
  },
];

MooX::Types::MooseLike::register_types($type_definitions, __PACKAGE__);
our %EXPORT_TAGS = ( 'all' => \@EXPORT_OK );

1