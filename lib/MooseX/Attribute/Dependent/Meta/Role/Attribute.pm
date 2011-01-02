package MooseX::Attribute::Dependent::Meta::Role::Attribute;
use strict;
use warnings;
use Moose::Role;

has dependency => ( predicate => 'has_dependency', is => 'ro' );

before initialize_instance_slot => sub {
    my ( $self, $meta_instance, $instance, $params ) = @_;
    return
      unless ( exists $params->{ $self->init_arg }
        && ( my $dep = $self->dependency ) );
    $self->throw_error( $dep->get_message, object => $instance )
      unless (
        $dep->constraint->( $self->init_arg, $params, @{ $dep->parameters } ) );
};

override _inline_check_required => sub {
    my $attr = shift;
    my @code = super();
    return @code
      if ( !$attr->does('MooseX::Attribute::Dependent::Meta::Role::Attribute')
        || !$attr->has_dependency
        || !$attr->init_arg );
    my @source;
    my $related =
      "'" . join( "', '", @{ $attr->dependency->parameters } ) . "'";
    push @source => $attr->_inline_throw_error(
        '"' . quotemeta( $attr->dependency->get_message ) . '"' );
    push @source => "unless("
      . $attr->dependency->name
      . "->constraint->(\""
      . quotemeta( $attr->name )
      . "\", \$_[0], $related));";

    return join( "\n", @source, @code );
};

1;
