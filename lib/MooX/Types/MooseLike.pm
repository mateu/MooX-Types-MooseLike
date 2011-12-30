use strictures 1;

package MooX::Types::MooseLike;
use Sub::Quote qw(quote_sub);
use base qw(Exporter);
use Data::Dumper::Concise;

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
	  no strict 'refs'; ## no critic
  	  *$type_full_name        = $coderefs->{type};
  	  *$is_type_full_name     = $coderefs->{is_type};
  	  *$assert_type_full_name = $coderefs->{assert_type};
      push @{"${namespace}::EXPORT_OK"}, $type_name, $is_type_name, $assert_type_name;
  	}
  	return;
  }
  
  sub make_type {
  	my ($type_name, $type_definition, $namespace) = @_;
  	$namespace ||= __PACKAGE__;
    my $assertion = 'assert_' . $type_name;
    my $assert_type_full_name = $namespace . '::' . $assertion;
    my $msg  = $type_definition->{message};
    my $test = $type_definition->{test};
    my $subtype_of = $type_definition->{subtype_of}||'Any';
	my $from = $type_definition->{from}||'MooX::Types::MooseLike::Base';
    
    my $full_test = sub {
      my $subtype_test = $from . '::is_' . $subtype_of;
	  no strict 'refs'; ## no critic
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
    
    # Also supporting is_$type.  For example, is_Int() can be used as follows
    has 'legal_age' => (
        is => 'ro',
        isa => sub { die "$_[0] is not of legal age" 
        	           unless (is_Int($_[0]) && $_[0] > 17) },
    );

=head1 SUBROUTINES (Types)

=head2 Any

Any type (test is always true)

=head2 Item

Synonymous with Any type 

=head2 Undef

A type that is not defined

=head2 Defined

A type that is defined

=head2 Bool

A boolean 1|0 type

=head2 Value

A non-reference type

=head2 Ref

A reference type

=head2 Str

A non-reference type where a reference to it is a SCALAR

=head2 Num

A number type

=head2 Int

An integer type

=head2 ArrayRef

An ArrayRef (ARRAY) type

=head2 HashRef

A HashRef (HASH) type

=head2 CodeRef

A CodeRef (CODE) type

=head2 RegexpRef

A regular expression reference type

=head2 GlobRef

A glob reference type

=head2 FileHandle

A type that is either a builtin perl filehandle or an IO::Handle object

=head2 Object

A type that is an object (think blessed)

=head2 AHRef

An ArrayRef[HashRef] type

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
