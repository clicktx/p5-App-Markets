use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::List::CartItems';
use_ok $pkg;

my $construct = sub { Yetie::Domain::Factory->new('list-cart_items')->construct(@_) };

subtest 'basic' => sub {
    my $v = $construct->();
    isa_ok $v, 'Yetie::Domain::List';
};

subtest 'total_quantity' => sub {
    my $v = $construct->( { list => [ { quantity => 1 }, { quantity => 2 } ] } );
    is $v->total_quantity, 3, 'right total quantity';
};

done_testing();
