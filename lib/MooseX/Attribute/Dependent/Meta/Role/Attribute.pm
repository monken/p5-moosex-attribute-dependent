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

around accessor_metaclass => sub { 
    my ($orig) = (shift);
    my $class = shift->$orig(@_);
    return Moose::Meta::Class->create_anon_class(
        superclasses => [$class],
        roles => ['MooseX::Attribute::Dependent::Meta::Role::Method::Accessor'],
        cache => 1
    )->name;
    
} if Moose->VERSION < 1.9900;

around _inline_check_required => sub {
    my $orig = shift;
    my $attr = shift;
    my @code = $attr->$orig(@_);
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
} if Moose->VERSION >= 1.9900;

1;