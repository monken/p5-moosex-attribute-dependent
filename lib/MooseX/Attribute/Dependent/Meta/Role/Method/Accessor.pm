package MooseX::Attribute::Dependent::Meta::Role::Method::Accessor;

# ABSTRACT: Lazy inflate attributes
use base 'Moose::Meta::Method::Accessor';
use strict;
use warnings;

sub _inline_check_constraint {
    my ( $self, $val ) = @_;
    my $code = $self->next::method($val);
    my $attr = $self->{attribute};
    
    return $code
        if( !$attr->does('MooseX::Attribute::Dependent::Meta::Role::Attribute')
            || !$attr->has_dependency
            || !$attr->init_arg);
    my @source;
    my $related = "'" . join("', '", @{$attr->dependency->parameters}) . "'";
    push @source => $self->_inline_throw_error( '"' . quotemeta($attr->dependency->get_message) . '"' );
    push @source => "unless(" . $attr->dependency->name . "->constraint->(\"" . quotemeta($attr->name) . "\", \$_[0], $related));";
    
    return join("\n", $code, @source);
}

1;
