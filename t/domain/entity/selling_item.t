use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::SellingItem';

subtest 'basic' => sub {
    my $item = Yetie::Domain::Entity::SellingItem->new(
        {
            id            => 2,
            product_id    => 111,
            product_title => 'test product',
            quantity      => 1,
            price         => 100,
        }
    );

    is $item->id,            2,              'right id';
    is $item->product_id,    111,            'right product_id';
    is $item->product_title, 'test product', 'right product_title';
    is $item->quantity,      1,              'right quantity';
    is $item->price,         100,            'right price';
    is $item->is_modified,   0,              'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';
};

subtest 'subtotal' => sub {
    my $item = Yetie::Domain::Entity::SellingItem->new(
        {
            quantity => 2,
            price    => 300,
        }
    );
    is $item->subtotal, 600, 'right subtotal';
};

subtest 'to_digest' => sub {
    my $item = Yetie::Domain::Entity::SellingItem->new(
        {
            product_id => 111,
        }
    );
    is $item->to_digest, '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right identify';
};

done_testing();
