package MooX::Types::MooseLike;
use strict;
use warnings FATAL => 'all';
use Exporter 5.57 'import';
use Module::Runtime qw(require_module);
use Carp qw(confess croak);

our $VERSION = '0.15';

sub register_types {
  my ($type_definitions, $into, $moose_namespace) = @_;
  foreach my $type_def (@{$type_definitions}) {
    my $coderefs = make_type($type_def, $moose_namespace);
    install_type($type_def->{name}, $coderefs, $into);
  }
  return;
}

sub install_type {
  my ($type_name, $coderefs, $namespace) = @_;
  my $is_type_name      = 'is_' . $type_name;
  my $type_full_name    = $namespace . '::' . $type_name;
  my $is_type_full_name = $namespace . '::' . $is_type_name;

  {
    no strict 'refs';    ## no critic qw(TestingAndDebugging::ProhibitNoStrict)
    *{$type_full_name}    = $coderefs->{type};
    *{$is_type_full_name} = $coderefs->{is_type};
    push @{"${namespace}::EXPORT_OK"}, $type_name, $is_type_name;
  }
  return;
}

sub make_type {
  my ($type_definition, $moose_namespace) = @_;
  my $test = $type_definition->{test};

  my $full_test = $test;
  if (my $subtype_of = $type_definition->{subtype_of}) {
    my $die_message =
      "Must define a 'from' namespace for the parent type: $subtype_of when defining type: $type_definition->{name}";
    my $from = $type_definition->{from}
      || croak $die_message; ## no critic qw(ErrorHandling::RequireUseOfExceptions)
    my $subtype_test = $from . '::is_' . $subtype_of;
    no strict 'refs';    ## no critic qw(TestingAndDebugging::ProhibitNoStrict)
    $full_test = sub { return (&{$subtype_test}(@_) && $test->(@_)); };
  }

  my $isa = sub {
    return if $full_test->(@_);
    local $Carp::Internal{"MooX::Types::MooseLike"} = 1;  ## no critic qw(Variables::ProhibitPackageVars)
    confess $type_definition->{message}->(@_) ;  ## no critic qw(ErrorHandling::RequireUseOfExceptions)
    };

  my $full_name =
    $moose_namespace
    ? "${moose_namespace}::" . $type_definition->{name}
    : $type_definition->{name};

  $Moo::HandleMoose::TYPE_MAP{$isa} = sub {
    require_module($moose_namespace) if $moose_namespace;
    Moose::Util::TypeConstraints::find_type_constraint($full_name);
    };

  return {
    type => sub {

      my $param = $_[0];

      # If we have a parameterized type then we want to check its values
      if (ref($param) eq 'ARRAY') {
        my $coderef           = $_[0]->[0];
        my $parameterized_isa = sub {
          if(ref($coderef) eq 'CODE') {
            $isa->(@_);

            # Run the type coderef on each value
            my @values = $type_definition->{parameterizable}->(@_);
            foreach my $value (@values) {
              $coderef->($value);
            }
          }
          else {
            $isa->(@_, @{$param});
          }
          };

        # Remove old $isa, but return the rest of the arguments
        # so any specs defined after 'isa' don't get lost
        shift;
        return ($parameterized_isa, @_);
      }
      else {
        return $isa;
      }
      },
    is_type => sub { $full_test->(@_) },
    };
}

1;
__END__

=head1 NAME

MooX::Types::MooseLike - some Moosish types and a type builder

=head1 SYNOPSIS

    package MyApp::Types;
    use MooX::Types::MooseLike;
    use base qw(Exporter);
    our @EXPORT_OK = ();

    # Define some types
    my $defs = [{
      name => 'MyType',
      test => sub { predicate($_[0]) },
      message => sub { "$_[0] is not the type we want!" }
    },
    {
      name => 'VarChar',
      test => sub {
        my ($value, $param) = @_;
        length($value) <= $param;
      },
      message => sub { "$_[0] is too large! It should be less than or equal to $_[1]." }
    }];

    # Make the types available - this adds them to @EXPORT_OK automatically.
    MooX::Types::MooseLike::register_types($defs, __PACKAGE__);

    ...

    # Somewhere in code that uses the type
    package MyApp::Foo;
    use Moo;
    use MyApp::Types qw(MyType VarChar);
    has attribute => (
      is  => 'ro',
      isa => MyType,
    );

    has string => (
      is  => 'ro',
      isa => VarChar[25]
    );

=head1 DESCRIPTION

See L<MooX::Types::MooseLike::Base> for a list of available base types.  
Its source also provides an example of how to build base types, along 
with both parameterizable and non-parameterizable.

See L<MooX::Types::MooseLike::Numeric> for an example of how to build subtypes.

See L<MooX::Types::SetObject> for an example of how to build parameterized types.

=head1 AUTHOR

mateu - Mateu X. Hunter (cpan:MATEU) <hunter@missoula.org>

=head1 CONTRIBUTORS

mst - Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>

Mithaldu - Christian Walde (cpan:MITHALDU) <walde.christian@googlemail.com>

Matt Phillips (cpan:MATTP) <mattp@cpan.org>

Arthur Axel fREW Schmidt (cpan:FREW) <frioux@gmail.com>

=head1 COPYRIGHT

Copyright (c) 2011-2012 the MooX::Types::MooseLike L</AUTHOR> and
 L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
