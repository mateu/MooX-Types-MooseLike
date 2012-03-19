use strictures 1;
package MooX::Types::MooseLike;
use Exporter 5.57 'import';

sub register_types {
  my ($type_definitions, $into) = @_;
  foreach my $type_def (@{$type_definitions}) {
    my $coderefs = make_type($type_def);
    install_type($type_def->{name}, $coderefs, $into);
  }
}

sub install_type {
  my ($type_name, $coderefs, $namespace) = @_;
  my $is_type_name          = 'is_' . $type_name;
  my $type_full_name        = $namespace . '::' . $type_name;
  my $is_type_full_name     = $namespace . '::' . $is_type_name;

  {
    no strict 'refs';    ## no critic
    *{$type_full_name} = $coderefs->{type};
    *{$is_type_full_name} = $coderefs->{is_type};
    push @{"${namespace}::EXPORT_OK"}, $type_name, $is_type_name;
  }
  return;
}

sub make_type {
  my ($type_definition) = @_;
  my $test = $type_definition->{test};
 
  my $full_test = $test; 
  if (my $subtype_of = $type_definition->{subtype_of}) {
    my $from = $type_definition->{from} || die "Must define a 'from' namespace for the parent type: $subtype_of
 when defining type: $type_definition->{name}";
    my $subtype_test = $from . '::is_' . $subtype_of;
    no strict 'refs';    ## no critic
    $full_test = sub {return (&{$subtype_test}(@_) && $test->(@_)); };
  }

  return {
    type    =>  sub {
      sub { die $type_definition->{message}->(@_) if not $full_test->(@_); };
    },
    is_type => sub { $test->($_[0]) },
  };
}

1;
__END__ 

=head1 NAME

MooX::Types::MooseLike - some Moosish types and a typer builder

=head1 SYNOPSIS

    # The Base and Numeric types are stable
    # but the API to build new types is Experimental
    package MyApp::Types;
    use MooX::Types::MooseLike::Base;
    use base qw(Exporter);
    our @EXPORT_OK = ();
    my $defs = [{ 
      name => 'MyType', 
      test => sub { predicate($_[0]) }, 
      message => sub { "$_[0] is not the type we want!" }
    }];
    MooX::Types::MooseLike::register_types($defs, __PACKAGE__);
    # optionally add an 'all' tag so one can:
    # use MyApp::Types qw/:all/; # to import all types
    our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

=head1 DESCRIPTION

See L<MooX::Types::MooseLike::Base> for an example of how to build base types.

See L<MooX::Types::MooseLike::Numeric> for an example of how to build subtypes.


