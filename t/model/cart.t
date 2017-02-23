use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Model::Cart';
my $model = Markets::Model::Cart->new;

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
