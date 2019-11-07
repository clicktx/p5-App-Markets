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
    my $rs = $schema->resultset('Preference');

    subtest 'basic' => sub {
        my $itr   = $rs->search( { id => 1 } );
        my @array = $itr->to_array;
        my $array = $itr->to_array;

        is @array, 1, 'right array';
        is ref $array, 'ARRAY', 'right array refference';

        my @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(default_value group_id id name position summary title value)], 'right all columns';
    };

    subtest 'options' => sub {
        my $itr = $rs->search( { id => 1 } );

        my @array = $itr->to_array( ignore_columns => [qw(id name position)] );
        my @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(default_value group_id summary title value)], 'right option "ignore_columns"';

        @array = $itr->to_array( columns => [qw(id name position)] );
        @keys = sort( keys %{ $array[0] } );
        is_deeply \@keys, [qw(id name position)], 'right option "columns"';
    };
};

subtest 'to_data' => sub {
    my $rs    = $schema->resultset('Sales');
    my $order = $rs->search()->to_data;

    is ref $order, 'ARRAY', 'right types';
};

subtest 'each' => sub {
    my $rs = $schema->resultset('Sales');
    my $order = $rs->find( 1, { prefetch => { sales_orders => [ 'shipping_address', 'items' ] } }, );

    subtest 'basic' => sub {
        my @res = $order->sales_orders->each;
        is @res, 2;
    };

    subtest 'default argument' => sub {
        my ( @res, @items );
        $order->sales_orders->each(
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
        $order->sales_orders->each(
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
