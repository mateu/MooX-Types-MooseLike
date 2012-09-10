package MooX::Types::SetObject;
use strict;
use warnings FATAL => 'all';
use MooX::Types::MooseLike;
use Scalar::Util;
use Exporter 5.57 'import';
our @EXPORT_OK = ();

my $type_definitions = [
  {
    name => 'SetObject',
    test => sub {
      require Scalar::Util;
      Scalar::Util::blessed($_[0]) && $_[0]->isa("Set::Object");
      },
    message         => sub { "$_[0] is not a Set::Object!" },
    parameterizable => sub { $_[0]->members },
  },
  ];

MooX::Types::MooseLike::register_types($type_definitions, __PACKAGE__);
our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

1;

__END__

=head1 NAME

MooX::Types::SetObject - Set::Object type

=head1 SYNOPSIS

    package MyPackage;
    use Moo;
    use MooX::Types::MooseLike::Base qw(Int);
    use MooX::Types::SetObject qw(SetObject);

    # a Set::Object of integers
    has "int_objects" => (
        isa => SetObject[Int],
    );
