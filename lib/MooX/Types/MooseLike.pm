use strictures 1;

package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use base qw(Exporter);

sub register_types {
  my ($type_definitions, $into) = @_;
  foreach my $type_def (@{$type_definitions}) {

    # Skip if not well-defined, i.e. the def has no test or message
    my $type_name = $type_def->{name};
    next unless defined $type_name;
    my $coderefs = make_type($type_name, $type_def, $into);
    install_type($type_name, $coderefs, $into);
  }
}

sub install_type {
  my ($type_name, $coderefs, $namespace) = @_;
  $namespace ||= __PACKAGE__;
  my $is_type_name          = 'is_' . $type_name;
  my $assert_type_name      = 'assert_' . $type_name;
  my $type_full_name        = $namespace . '::' . $type_name;
  my $is_type_full_name     = $namespace . '::' . $is_type_name;
  my $assert_type_full_name = $namespace . '::' . $assert_type_name;

  {
    no strict 'refs';    ## no critic
    *$type_full_name        = $coderefs->{type};
    *$is_type_full_name     = $coderefs->{is_type};
    *$assert_type_full_name = $coderefs->{assert_type};
    push @{"${namespace}::EXPORT_OK"}, $type_name, $is_type_name,
      $assert_type_name;
  }
  return;
}

sub make_type {
  my ($type_name, $type_definition, $namespace) = @_;
  $namespace ||= __PACKAGE__;
  my $assertion             = 'assert_' . $type_name;
  my $assert_type_full_name = $namespace . '::' . $assertion;
  my $msg                   = $type_definition->{message};
  my $test                  = $type_definition->{test};
  my $subtype_of            = $type_definition->{subtype_of} || 'Any';
  my $from = $type_definition->{from} || 'MooX::Types::MooseLike::Base';

  my $full_test = sub {
    my $subtype_test = $from . '::is_' . $subtype_of;
    no strict 'refs';    ## no critic
    return (&{$subtype_test}(@_) && $test->(@_));
  };
  my $assert_type = quote_sub $assert_type_full_name => q{
        die $msg->(@_) if not $test->(@_);
    }, { '$msg' => \$msg, '$test' => \$full_test };

  return {
    type        => sub { $namespace->can($assertion) },
    is_type     => sub { $test->($_[0]) },
    assert_type => $assert_type
  };
}

1;
__END__ 

=head1 NAME

MooX::Types::MooseLike - some Moosish types and a typer builder

=head1 SYNOPSIS

	# API Experimental
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
	# optionally add an 'all' tags option (use MyApp::Types qw/:all/; # to import all types)
	our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

=head1 DESCRIPTION

See L<MooX::Types::MooseLike::Base> for an example of how to build base types.

See L<MooX::Types::MooseLike::Numeric> for an example of how to build subtypes.


