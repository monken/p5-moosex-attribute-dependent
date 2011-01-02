package MooseX::Attribute::Dependent::Meta::Role::Class;

use strict;
use warnings;
use Moose::Role;

override _inline_check_required_attr => sub {
    my ($self, $attr, $idx) = @_;
    return super() 
        if(!$attr->does('MooseX::Attribute::Dependent::Meta::Role::Attribute')
            || !$attr->has_dependency
            || !$attr->init_arg);
    my @source;
    my $related = "'" . join("', '", @{$attr->dependency->parameters}) . "'";
    push @source => 'if(exists $params->{' . $attr->init_arg . '}) {';
    push @source => $self->_inline_throw_error( '"' . quotemeta($attr->dependency->get_message) . '"' );
    push @source => "unless(" . $attr->dependency->name . "->constraint->(\"" . quotemeta($attr->init_arg) . "\", \$params, $related));";
    push @source => '}';
    return join("\n", @source, super());
};


1;