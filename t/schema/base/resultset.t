use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales::Order::Shipment::Item');

subtest 'basic' => sub {
    my $itr   = $rs->search( { shipment_id => 1 } );
    my @array = $itr->to_array;
    my $array = $itr->to_array;

    is @array, 2, 'right array';
    is ref $array, 'ARRAY', 'right array refference';

    my @keys = sort( keys %{ $array[0] } );
    is_deeply \@keys, [qw(id price product_id product_title quantity shipment_id)], 'right all columns';
};

subtest 'options' => sub {
    my $itr = $rs->search( { shipment_id => 1 } );

    my @array = $itr->to_array( ignore_columns => [qw(product_title shipment_id)] );
    my @keys = sort( keys %{ $array[0] } );
    is_deeply \@keys, [qw(id price product_id quantity)], 'right option "ignore_columns"';

    @array = $itr->to_array( columns => [qw(product_title shipment_id)] );
    @keys = sort( keys %{ $array[0] } );
    is_deeply \@keys, [qw(product_title shipment_id)], 'right option "columns"';
};

done_testing();
