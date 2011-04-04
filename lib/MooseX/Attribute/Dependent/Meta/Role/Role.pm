package MooseX::Attribute::Dependent::Meta::Role::Role;
use Moose::Role;

sub composition_class_roles {
    'MooseX::Attribute::Dependent::Meta::Role::Composite'
}

no Moose::Role;

1;
