use Test::Most;
use MooseX::Attribute::Dependency;

sub All {
  my $args = shift;
  MooseX::Attribute::Dependency->new( parameters => $args );
}

ok(All['abc']);

done_testing;