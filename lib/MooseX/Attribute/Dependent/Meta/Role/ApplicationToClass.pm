package MooseX::Attribute::Dependent::Meta::Role::ApplicationToClass;
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my $role  = shift;
    my $class = shift;
    $class =
      Moose::Util::MetaRole::apply_metaroles(
        for             => $class,
        class_metaroles => {
            (Moose->VERSION >= 1.9900
                ? (class =>
                    ['MooseX::Attribute::Dependent::Meta::Role::Class'])
                : (constructor =>
                    ['MooseX::Attribute::Dependent::Meta::Role::Method::Constructor'])),
            attribute => ['MooseX::Attribute::Dependent::Meta::Role::Attribute'],
        });
    $self->$orig( $role, $class );
};

1;
