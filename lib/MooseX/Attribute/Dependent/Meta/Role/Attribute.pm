package MooseX::Attribute::Dependent::Meta::Role::Attribute;
use strict;
use warnings;
use Moose::Role;
use Scalar::Util qw(blessed);

has dependency => ( predicate => 'has_dependency', is => 'ro' );


before initialize_instance_slot => sub {
    my ( $self, $meta_instance, $instance, $params ) = @_;
    return unless ( exists $params->{$self->init_arg} && (my $dep = $self->dependency) );
    $self->throw_error( $dep->get_message, object => $instance )
      unless ( $dep->constraint->( $self->init_arg, $params, @{ $dep->parameters } ) );
};


use MooseX::Attribute::Dependent::Meta::Role::Method::Accessor;
sub accessor_metaclass { 'MooseX::Attribute::Dependent::Meta::Role::Method::Accessor' }

1;
