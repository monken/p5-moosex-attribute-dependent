package MooseX::Attribute::Dependency;
use Moose;
has [qw(parameters message constraint name)] => ( is => 'ro' );

sub get_message {
    my ($self) = @_;
    sprintf( $self->message, join( ', ', @{ $self->parameters } ) );
}

use overload( bool => sub { 1 } );

my $meta = Class::MOP::Class->initialize('MooseX::Attribute::Dependencies');

sub register {
    my ($args) = @_;
    no strict 'refs';
    my $name = 'MooseX::Attribute::Dependencies::' . $args->{name};
    $meta->add_method( $args->{name}, sub {
        my $params = shift;
        MooseX::Attribute::Dependency->new(%$args, name => $name, parameters => $params);
      });
}

__PACKAGE__->meta->make_immutable;

package MooseX::Attribute::Dependencies;
use strict;
use warnings;

MooseX::Attribute::Dependency::register({
    name       => 'All',
    message    => 'The following attributes are required: %s',
    constraint => sub {
        my ( $attr_name, $params, @related ) = @_;
        return List::MoreUtils::all { exists $params->{$_} } @related;
    }
});

MooseX::Attribute::Dependency::register({
    name       => 'Any',
    message    => 'At least one of the following attributes is required: %s',
    constraint => sub {
        my ( $attr_name, $params, @related ) = @_;
        return List::MoreUtils::any { exists $params->{$_} } @related;
    }
});

MooseX::Attribute::Dependency::register({
    name       => 'None',
    message    => 'None of the following attributes can have a value: %s',
    constraint => sub {
        my ( $attr_name, $params, @related ) = @_;
        return List::MoreUtils::none { exists $params->{$_} } @related;
    }
});

MooseX::Attribute::Dependency::register({
    name       => 'NotAll',
    message    => 'At least one of the following attributes cannot have a value: %s',
    constraint => sub {
        my ( $attr_name, $params, @related ) = @_;
        return List::MoreUtils::notall { exists $params->{$_} } @related;
    }
});


1;
