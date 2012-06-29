package MooX::Types::MooseLike;

use strictures 1;
use Exporter 5.57 'import';
use Module::Runtime qw(require_module);
use Carp qw(confess);

our $VERSION = '0.07';

sub register_types {
  my ($type_definitions, $into, $moose_namespace) = @_;
  foreach my $type_def (@{$type_definitions}) {
    my $coderefs = make_type($type_def, $moose_namespace);
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
  my ($type_definition, $moose_namespace) = @_;
  my $test = $type_definition->{test};
 
  my $full_test = $test; 
  if (my $subtype_of = $type_definition->{subtype_of}) {
    my $from = $type_definition->{from} || die "Must define a 'from' namespace for the parent type: $subtype_of
 when defining type: $type_definition->{name}";
    my $subtype_test = $from . '::is_' . $subtype_of;
    no strict 'refs';    ## no critic
    $full_test = sub {return (&{$subtype_test}(@_) && $test->(@_)); };
  }

  my $isa = sub {
    return if $full_test->(@_);
    local $Carp::Internal{"MooX::Types::MooseLike"} = 1;
    confess $type_definition->{message}->(@_);
  };

  my $full_name = $moose_namespace
                    ? "${moose_namespace}::".$type_definition->{name}
                    : $type_definition->{name};

  $Moo::HandleMoose::TYPE_MAP{$isa} = sub {
    require_module($moose_namespace) if $moose_namespace;
    Moose::Util::TypeConstraints::find_type_constraint($full_name);
  };

  return {
    type    =>  sub { 

      # If we have a parameterized type we want to check its values
      if (
            $_[0] 
        &&  $_[0]->[0] 
        &&  ref($_[0]->[0]) 
        && (ref($_[0]->[0]) eq 'CODE')
      ) {
        my $coderef = $_[0]->[0]; 
        sub {
             $isa->(@_);
             my @values;
             if ($type_definition->{name} eq 'ArrayRef'){
                 @values = @{$_[0]};
             }
             elsif ($type_definition->{name} eq 'HashRef'){
                 @values = values %{$_[0]};
             }
             elsif ($type_definition->{name} eq 'ScalarRef'){
                 @values = (${$_[0]});
             }
             foreach my $value (@values) {
                $coderef->($value);
             }
        };
      }
      else {
          $isa;
      }
    },
    is_type => sub { $full_test->($_[0]) },
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

=head1 AUTHOR

mateu - Mateu X. Hunter (cpan:MATEU) <hunter@missoula.org>

=head1 CONTRIBUTORS

mst - Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>
Mithaldu - Christian Walde (cpan:MITHALDU) <walde.christian@googlemail.com>

=head1 COPYRIGHT

Copyright (c) 2011-2012 the MooX::Types::MooseLike L</AUTHOR> and
 L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
