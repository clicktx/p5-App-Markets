use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Model::Cart';
my $model = Markets::Model::Cart->new;

my $params = { fizz => 1, buzz => 1, product_id => 1, quantity => 1 };

subtest 'add_item' => sub {
    my $item = $model->item($params);
    my $items;
    $items = $model->add_item( $item, $items );
    is_deeply $items->to_array, [$item], 'right add item';

    $items = $model->add_item( $item, $items );
    is $items->to_array->[0]->{quantity}, 2, 'right re-add item';

    $items = $model->add_item( { product_id => 2, quantity => 2 }, $items );
    is $items->to_array->[1]->{product_id}, 2, 'right add another item';

    $items = $model->add_item( {}, $items );
    is $items->size, 2, 'right add empty item';
};

subtest 'item' => sub {
    my $item = $model->item($params);
    is ref $item, 'HASH', 'right refference';
    is_deeply $item, { product_id => 1, quantity => 1 }, 'right component';
};

subtest 'items' => sub {
    my $cart_data = {
        items => [ [ {}, {}, ], [ {}, {}, ], ],
        hoge  => 1,
        fuga  => 1,
    };
    my $items = $model->items($cart_data);
    is ref $items->[0], 'Mojo::Collection';
    is ref $items->[1], 'Mojo::Collection';
    is ref $items->[2], '';
    is $items->[0]->size, 2;
    is_deeply $items->[0]->first, {};

    # empty data
    is ref $model->items( {} ), 'Mojo::Collection', 'right cart data empty hash';
    is ref $model->items(undef), 'Mojo::Collection', 'right cart data undefind';
    is ref $model->items(''),    'Mojo::Collection', 'right cart data empty';
};

subtest 'merge_cart' => sub {
    my $cart   = '';
    my $stored = '';
    my $merged = $model->merge_cart( $cart, $stored );
    is_deeply $merged, { items => [ [], ] }, 'right item empty';

    $cart   = {};
    $stored = {};
    $merged = $model->merge_cart( $cart, $stored );
    is_deeply $merged, { items => [ [], ] }, 'right item empty';

    $cart   = { items => [ [ {} ] ] };
    $stored = {};
    $merged = $model->merge_cart( $cart, $stored );
    is_deeply $merged, { items => [ [ {} ] ] }, 'right cart only';

    $cart   = {};
    $stored = { items => [ [ {} ] ] };
    $merged = $model->merge_cart( $cart, $stored );
    is_deeply $merged, { items => [ [ {} ] ] }, 'right stored only';

    $cart = {
        items => [
            [
                { product_id => 1, quantiry => 10 },
                { product_id => 3, quantiry => 10 },
                { product_id => 5, quantiry => 10 },
                { product_id => 7, quantiry => 10 },
            ],
        ],
    };
    $stored = {
        items => [
            [
                { product_id => 1, quantiry => 1 },
                { product_id => 2, quantiry => 1 },
                { product_id => 3, quantiry => 1 },
            ],
            [
                { product_id => 4, quantiry => 1 },
                { product_id => 5, quantiry => 1 },
                { product_id => 6, quantiry => 1 },
                { product_id => 7, quantiry => 1 },
            ],
        ]
    };
    $merged = $model->merge_cart( $cart, $stored );
    is_deeply $merged,
      {
        items => [
            [
                { product_id => 2, quantiry => 1 },
                { product_id => 4, quantiry => 1 },
                { product_id => 6, quantiry => 1 },
                { product_id => 1, quantiry => 10 },
                { product_id => 3, quantiry => 10 },
                { product_id => 5, quantiry => 10 },
                { product_id => 7, quantiry => 10 },
            ],
        ],
      },
      'right merged cart';
};

done_testing();
