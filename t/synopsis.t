package MyApp::Types;
use MooseX::Attribute::Dependency;

BEGIN { MooseX::Attribute::Dependency::register({
       name               => 'SmallerThan',
       message => 'The value must be smaller than ',
       constraint         => sub {
           my ($attr_name, $params, @related) = @_;
           return List::MoreUtils::all { $params->{$attr_name} < $params->{$_} } @related;
       },
   }
); }

warn 1;

package MyClass;
use Moose;
use MooseX::Attribute::Dependent;

has small => ( is => 'rw', dependency => SmallerThan['large'] );
has large => ( is => 'rw' );

warn 2;

package main;
use Test::Most;

dies_ok { MyClass->new( small => 10, large => 1) };
lives_ok { MyClass->new( small => 1, large => 10) };

warn 3; 
done_testing;