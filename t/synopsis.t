package MyApp::Types;
use MooseX::Types -declare => [qw(SmallerThan)];
use Moose::Util::TypeConstraints;
use strict;
use warnings;
use MooseX::Dependency::TypeConstraint;
use List::MoreUtils ();

my $REGISTRY = Moose::Util::TypeConstraints->get_type_constraint_registry;
$REGISTRY->add_type_constraint(
   MooseX::Dependency::TypeConstraint->new(
       name               => SmallerThan,
       package_defined_in => __PACKAGE__,
       parent             => find_type_constraint('Item'),
       message => 'The value must be smaller than ',
       constraint         => sub {
           my ($attr_name, $params, @related) = @_;
           return List::MoreUtils::all { $params->{$attr_name} < $params->{$_} } @related;
       },
   )
);

package MyClass;
use MooseX::Dependency;

has small => ( is => 'rw', dependency => MyApp::Types::SmallerThan['large'] );
has large => ( is => 'rw' );

package main;
use Test::Most;

dies_ok { MyClass->new( small => 10, large => 1) };
lives_ok { MyClass->new( small => 1, large => 10) };

done_testing;