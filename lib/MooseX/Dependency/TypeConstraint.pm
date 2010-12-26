package MooseX::Dependency::TypeConstraint;

use strict;
use warnings;
use metaclass;

use List::MoreUtils qw(all);

use Moose::Util::TypeConstraints ();

use base 'Moose::Meta::TypeConstraint';

__PACKAGE__->meta->add_attribute('related' => (
    accessor => 'related',
));


my $REGISTRY = Moose::Util::TypeConstraints->get_type_constraint_registry;

sub parameterize {
    my ($self, @params) = @_;
    $self->related(\@params);
    return $self;
}

sub get_message {
    my $self = shift;
    return $self->message . join(", ", @{$self->related});
}

1;