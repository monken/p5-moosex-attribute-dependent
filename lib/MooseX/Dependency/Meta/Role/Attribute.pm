package MooseX::Dependency::Meta::Role::Attribute;
use strict;
use warnings;
use Moose::Role;
use Scalar::Util qw(blessed);

has dependency => ( predicate => 'has_dependency', is => 'ro' );

after _process_options => sub {
    my ( $class, $name, $options ) = @_;
    return unless ( my $dependency = $options->{dependency} );
    return
      if ( blessed($dependency)
        && $dependency->isa('MooseX::Dependency::TypeConstraint') );

    $options->{dependency} =
      Moose::Util::TypeConstraints::find_or_create_isa_type_constraint(
        $dependency);

};

before initialize_instance_slot => sub {
    my ( $self, $meta_instance, $instance, $params ) = @_;
    return unless ( exists $params->{$self->init_arg} && (my $dep = $self->dependency) );
    $self->throw_error( $dep->get_message, object => $instance )
      unless ( $dep->check( $self->init_arg, $params, @{ $dep->related } ) );
};


use MooseX::Dependency::Meta::Role::Method::Accessor;
sub accessor_metaclass { 'MooseX::Dependency::Meta::Role::Method::Accessor' }

1;
