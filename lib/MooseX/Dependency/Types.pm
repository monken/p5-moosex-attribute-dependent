package MooseX::Dependency::Types;

use MooseX::Types -declare => [qw(All Any None NotAll)];
use MooseX::Types::Moose qw(HashRef Object Str);
use Moose::Util::TypeConstraints;
use strict;
use warnings;
use MooseX::Dependency::TypeConstraint;
use List::MoreUtils ();

my $REGISTRY = Moose::Util::TypeConstraints->get_type_constraint_registry;


$REGISTRY->add_type_constraint(
    MooseX::Dependency::TypeConstraint->new(
        name               => All,
        package_defined_in => __PACKAGE__,
        parent             => find_type_constraint('Item'),
        message => 'The following attributes are required: ',
        constraint         => sub {
            my ($attr_name, $params, @related) = @_;
            return List::MoreUtils::all { exists $params->{$_} } @related;
        },
    )
);

$REGISTRY->add_type_constraint(
    MooseX::Dependency::TypeConstraint->new(
        name               => Any,
        package_defined_in => __PACKAGE__,
        parent             => find_type_constraint('Item'),
        message => 'At least one of the following attributes is required: ',
        constraint         => sub {
            my ($attr_name, $params, @related) = @_;
            return List::MoreUtils::any { exists $params->{$_} } @related;
        },
    )
);

$REGISTRY->add_type_constraint(
    MooseX::Dependency::TypeConstraint->new(
        name               => None,
        package_defined_in => __PACKAGE__,
        parent             => find_type_constraint('Item'),
        message => 'None of the following attributes can have a value: ',
        constraint         => sub {
            my ($attr_name, $params, @related) = @_;
            return List::MoreUtils::none { exists $params->{$_} } @related;
        },
    )
);

$REGISTRY->add_type_constraint(
    MooseX::Dependency::TypeConstraint->new(
        name               => NotAll,
        package_defined_in => __PACKAGE__,
        parent             => find_type_constraint('Item'),
        message => 'At least one of the following attributes cannot have a value: ',
        constraint         => sub {
            my ($attr_name, $params, @related) = @_;
            return List::MoreUtils::notall { exists $params->{$_} } @related;
        },
    )
);

1;