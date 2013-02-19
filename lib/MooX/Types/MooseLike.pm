package MooX::Types::MooseLike;
use strict;
use warnings FATAL => 'all';
use Exporter 5.57 'import';
our @EXPORT_OK;
push @EXPORT_OK, qw( exception_message inflate_type );
use Module::Runtime qw(require_module);
use Carp qw(confess croak);
use List::Util qw(first);

our $VERSION = '0.21';

sub register_types {
  my ($type_definitions, $into, $moose_namespace) = @_;
  foreach my $type_def (@{$type_definitions}) {
    if ($moose_namespace) {
      $type_def->{moose_namespace} ||= $moose_namespace;
    }
    my $coderefs = make_type($type_def);
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

sub make_isa {
  my ($type_definition) = @_;
  my $test = $type_definition->{test};

  if (my $subtype_of = $type_definition->{subtype_of}) {
    if (!ref $subtype_of) {
      my $from = $type_definition->{from}
        || croak "Must define a 'from' namespace for the parent type: $subtype_of when defining type: $type_definition->{name}";
      $subtype_of = do {
        no strict 'refs';
        \&{$from . '::' . $subtype_of};
      };
    }
    my $base_test = $test;
    $test = sub {
      my $value = shift;
      local $@;
      eval { $subtype_of->($value); 1 } or return;
      if ($base_test) {
        $base_test->($value) or return;
      }
      return 1;
    };
  }

  my $isa = sub {
    return if $test->(@_);
    local $Carp::Internal{"MooX::Types::MooseLike"} = 1;  ## no critic qw(Variables::ProhibitPackageVars)
    confess $type_definition->{message}->(@_) ;  ## no critic qw(ErrorHandling::RequireUseOfExceptions)
    };

  if (ref $type_definition->{inflate}) {
    $Moo::HandleMoose::TYPE_MAP{$isa} = $type_definition->{inflate};
  }
  elsif (exists $type_definition->{inflate} and not $type_definition->{inflate}) {
    # no-op
  }
  else {
    my $moose_namespace = $type_definition->{moose_namespace};
    my $full_name =
      defined $moose_namespace 
      ? "${moose_namespace}::" . $type_definition->{name}
      : $type_definition->{name};

    $Moo::HandleMoose::TYPE_MAP{$isa} = sub {
      require_module($moose_namespace) if $moose_namespace;
      Moose::Util::TypeConstraints::find_type_constraint($full_name);
      };
  }
  return $isa;
}

sub make_param_isa {
  my ($type_definition, $base_isa, $params) = @_;
  # 'parameterizable' types take types (coderefs) as params
  my $isa;
  if (my $parameterizer = $type_definition->{parameterizable}) {
    if(my $culprit = first { (ref($_) ne 'CODE') } @$params) {
      croak "Expect all parameters to be coderefs, but found: $culprit";
    }
    $isa = sub {
      # Check the containing type. We could pass @_, but it is such that: 
      # scalar @_ = 1 always in this context.  In other words,
      # an $isa only type checks one thing at a time.
      $base_isa->($_[0]);

      # Run the nested type coderefs on each value
      foreach my $coderef (@$params) {
        foreach my $value ($parameterizer->($_[0])) {
          $coderef->($value);
        }
      }
    };
  }
  else {
    $isa = sub {
      $base_isa->($_[0], @$params);
    };
  }

  if (ref $type_definition->{inflate}) {
    my $inflation = $type_definition->{inflate};
    $Moo::HandleMoose::TYPE_MAP{$isa} = sub { $inflation->($params) };
  }
  return $isa;
}

sub make_type {
  my ($type_def) = @_;
  my $isa = make_isa($type_def);
  my $is_type = sub {
    my $value = shift;
    local $@;
    eval { $isa->($value); 1 };
  };
  return {
    is_type => $is_type,
    type => sub {

      # If we have a parameterized type then we want to check its values
      if (ref($_[0]) eq 'ARRAY') {
        my $params = shift;
        return (make_param_isa($type_def, $isa, $params), @_);
      }
      else {
        return $isa;
      }
    },
  };
}

sub exception_message {
  my ($attribute_value, $type) = @_;
  $attribute_value = defined $attribute_value ? $attribute_value : 'undef';
  return "${attribute_value} is not ${type}!";
}

sub inflate_type {
  my $coderef = shift;
  if (my $inflator = $Moo::HandleMoose::TYPE_MAP{$coderef}) {
    return $inflator->();
  }
  return Moose::Meta::TypeConstraint->new(
    constraint => sub { eval { &$coderef; 1 } }
  );
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

Toby Inkster (cpan:TOBYINK) <tobyink@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2011-2013 the MooX::Types::MooseLike L</AUTHOR> and
 L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
