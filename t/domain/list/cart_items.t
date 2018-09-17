use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::List::CartItems';
use_ok $pkg;

my $construct = sub { Yetie::Domain::Factory->new('list-cart_items')->construct(@_) };

subtest 'basic' => sub {
    my $list = $construct->();
    isa_ok $list, 'Yetie::Domain::List';
};

subtest 'total_quantity' => sub {
    my $list = $construct->( list => [ { quantity => 1 }, { quantity => 2 } ] );
    is $list->total_quantity, 3, 'right total quantity';
};

subtest 'remove' => sub {
    my $data = [ { product_id => 1 }, { product_id => 2 }, { product_id => 3 } ];
    my $list = $construct->( list => $data );
    my $id   = $list->get(1)->id;
    my $new  = $list->remove($id);
    isa_ok $new, $pkg;
    is_deeply $list->to_data, $data, 'right immutable';
    is_deeply $new->to_data, [ { product_id => 1 }, { product_id => 3 } ], 'right remove item';
};

done_testing();
