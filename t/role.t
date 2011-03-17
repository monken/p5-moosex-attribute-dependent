use Test::Most 0.23;

package MyRole;
use Moose::Role;
use MooseX::Attribute::Dependent;

has street => ( is => 'rw', dependency => All['city', 'zip'] );
has city => ( is => 'ro' );
has zip => ( is => 'ro', clearer => 'clear_zip' );

package MyInterRole;
use Moose::Role;
with 'MyRole';

package All1;
use Moose;
with 'MyRole';

package All2;
use Moose;
with 'MyInterRole';

package main;

diag 'mutable';
for(1..4) 
{
    my $class = "All" . ( $_ % 2 + 1 );
    throws_ok { $class->new(street => 1) } qr/city/, 'city and zip are required';
    throws_ok { $class->new(street => 1, city => 1) } qr/city/, 'zip is required';
    lives_ok { $class->new(street => 1, city => 1, zip => 1) } 'lives ok';
    lives_ok { $class->new() } 'empty new lives ok';
    my $foo = $class->new;
    throws_ok { $foo->street("foo") } qr/city/, 'works on accessor as well';
    diag "making immutable" if($_ % 2);
    $class->meta->make_immutable;
}

done_testing;