package MooseX::Dependency::Meta::Role::Method::Constructor;

use strict;
use warnings;
use Moose::Role;

override _generate_slot_initializer => sub {
    my $self  = shift;
    my $index = shift;

    my $attr = $self->_attributes->[$index];
    my $is_moose = $attr->isa('Moose::Meta::Attribute'); # XXX FIXME
    
    return super() 
        if(!$is_moose 
            || !$attr->does('MooseX::Dependency::Meta::Role::Attribute')
            || !$attr->has_dependency
            || !$attr->init_arg);
    my @source;
    my $related = "'" . join("', '", @{$attr->dependency->related}) . "'";
    push @source => 'if(exists $params->{' . $attr->init_arg . '}) {';
    push @source => $self->_inline_throw_error( '"' . quotemeta($attr->dependency->get_message) . '"' );
    push @source => "unless(" . $attr->dependency->name . "->check(\"" . quotemeta($attr->init_arg) . "\", \$params, $related));";
    push @source => '}';
    return join("\n", @source, super());
};


1;
