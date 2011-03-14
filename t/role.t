use Test::Most 0.23;

package MyRole;
use Moose::Role;
use MooseX::Attribute::Dependent;

has street => ( is => 'rw', dependency => All['city', 'zip'] );
has city => ( is => 'ro' );
has zip => ( is => 'ro', clearer => 'clear_zip' );

package All;
use Moose;
use MooseX::Attribute::Dependent;
with 'MyRole';

package main;

diag 'mutable';
for(1..2) 
{
    throws_ok { All->new(street => 1) } qr/city/, 'city and zip are required';
    throws_ok { All->new(street => 1, city => 1) } qr/city/, 'zip is required';
    lives_ok { All->new(street => 1, city => 1, zip => 1) } 'lives ok';
    lives_ok { All->new() } 'empty new lives ok';
    my $foo = All->new;
    throws_ok { $foo->street("foo") } qr/city/, 'works on accessor as well';
    diag "making immutable" if($_ == 1);
    All->meta->make_immutable;
}

done_testing;