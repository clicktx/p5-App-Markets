use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Yetie::Schema::ResultSet::Sales::Order::Item';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('Sales::Order::Item');

subtest store_items => sub {
    my $items = $app->factory('entity-order_detail')->construct(
        id    => 1,
        items => [
            {
                id       => 1,
                quantity => 1
            },
            {
                id         => 99,
                product_id => 2,
                quantity   => 99
            },
        ]
    );
    $rs->store_items($items);

    my $item = $rs->find(1);
    is $item->quantity, 1, 'right update';

    $item = $rs->find(99);
    is $item->quantity, 99, 'right create';
};

done_testing();
