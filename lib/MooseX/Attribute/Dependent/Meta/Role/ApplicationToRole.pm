package MooseX::Attribute::Dependent::Meta::Role::ApplicationToRole;
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my $role  = shift;
    my $class = shift;
    $class =
      Moose::Util::MetaRole::apply_metaroles(
        for            => $class,
        role_metaroles => {
            attribute => ['MooseX::Attribute::Dependent::Meta::Role::Attribute'],
            application_to_class => ['MooseX::Attribute::Dependent::Meta::Role::ApplicationToClass'],
            application_to_role => ['MooseX::Attribute::Dependent::Meta::Role::ApplicationToRole'],

        },);
    $self->$orig( $role, $class );
};

1;
