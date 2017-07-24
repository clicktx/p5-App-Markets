use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Cart::Item';

subtest 'basic' => sub {
    my $item = Markets::Domain::Entity::Cart::Item->new(
        {
            product_id    => 111,
            product_title => 'test product',
            quantity      => 1,
            price         => 100,
        }
    );

    is $item->product_id,    111,            'right product_id';
    is $item->product_title, 'test product', 'right product_title';
    is $item->quantity,      1,              'right quantity';
    is $item->price,         100,            'right price';

    is $item->hash_code, '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right hash_code';
    is $item->is_modified, 0, 'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';

    my $item2 = Markets::Domain::Entity::Cart::Item->new(
        {
            product_id => 110,
            quantity   => 1,
        }
    );

    is $item->is_equal($item),  1, 'right equal item';
    is $item->is_equal($item2), 0, 'right not equal item';
};

subtest 'subtotal' => sub {
    my $item = Markets::Domain::Entity::Cart::Item->new(
        {
            quantity => 2,
            price    => 300,
        }
    );
    is $item->subtotal, 600, 'right subtotal';
};

done_testing();
