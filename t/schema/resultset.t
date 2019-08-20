use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;

subtest 'attribute' => sub {
    my $rs = $schema->resultset('Sales');
    isa_ok $rs->schema, 'Yetie::Schema';
};

subtest 'last_id' => sub {
    my $rs = $schema->resultset('Test');

    my $last_id = $rs->last_id;
    is $last_id, undef, 'right no data';

    $rs->create( { name => 'foo' } );
    $last_id = $rs->last_id;
    is $last_id, 1, 'right last id';

    $last_id = $rs->last_id( { name => 'foo' } );
    is $last_id, 1, 'right last id';
    $last_id = $rs->last_id( { name => 'bar' } );
    is $last_id, undef, 'right no data';
};

subtest 'limit' => sub {
    my $rs = $schema->resultset('Sales');

    my $res = $rs->search( {} )->limit(1);
    is $res->count, 1, 'right limit 1';

    $res = $rs->search( {} )->limit( 2, 3 );
    is $res->count, 3, 'right limit 3';
    is $res->first->id, 3, 'right offset first';
};

subtest 'to_array' => sub {
    my $rs = $schema->resultset('SalesOrderItem');

    subtest 'basic' => sub {
        my $itr   = $rs->search( { order_id => 1 } );
        my @array = $itr->to_array;
        my $array = $itr->to_array;

        is @array, 2, 'right array';
        is ref $array, 'ARRAY', 'right array refference';

        my @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(id order_id price product_id product_title quantity)], 'right all columns';
    };

    subtest 'options' => sub {
        my $itr = $rs->search( { order_id => 1 } );

        my @array = $itr->to_array( ignore_columns => [qw(product_title order_id)] );
        my @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(id price product_id quantity)], 'right option "ignore_columns"';

        @array = $itr->to_array( columns => [qw(product_title order_id)] );
        @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(order_id product_title)], 'right option "columns"';
    };
};

subtest 'to_data' => sub {
    my $rs    = $schema->resultset('Sales');
    my $order = $rs->search()->to_data;

    is ref $order, 'ARRAY', 'right types';
};

subtest 'each' => sub {
    my $rs = $schema->resultset('Sales');
    my $order = $rs->find( 1, { prefetch => { orders => [ 'shipping_address', 'items' ] } }, );

    subtest 'basic' => sub {
        my @res = $order->orders->each;
        is @res, 2;
    };

    subtest 'default argument' => sub {
        my ( @res, @items );
        $order->orders->each(
            sub {
                push @res, $_;
                $_->items->each( sub { push @items, $_ } );
            }
        );
        is @res,   2;
        is @items, 3;
    };

    subtest 'number' => sub {
        my ( @res, @num );
        $order->orders->each(
            sub {
                my ( $e, $n ) = @_;
                push @res, $e;
                push @num, $n;
            }
        );
        is @res, 2, 'right elements';
        is_deeply \@num, [ 1, 2 ], 'right numbers';
    };
};

done_testing();
