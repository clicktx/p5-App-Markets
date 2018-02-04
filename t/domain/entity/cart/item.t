use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Cart::Item';

subtest 'basic' => sub {
    my $item = Yetie::Domain::Entity::Cart::Item->new(
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
    is $item->is_modified, 0, 'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';

    my $item2 = Yetie::Domain::Entity::Cart::Item->new(
        {
            product_id => 110,
            quantity   => 1,
        }
    );

    is $item->equal($item),  1, 'right equal item';
    is $item->equal($item2), 0, 'right not equal item';
};

done_testing();
