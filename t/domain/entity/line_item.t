use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::LineItem';

subtest 'basic' => sub {
    my $item = Yetie::Domain::Entity::LineItem->new(
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

subtest 'equals' => sub {
    my $item1 = Yetie::Domain::Entity::LineItem->new(
        {
            product_id => 1,
        }
    );
    my $item2 = Yetie::Domain::Entity::LineItem->new(
        {
            product_id => 1,
        }
    );
    my $item3 = Yetie::Domain::Entity::LineItem->new(
        {
            product_id => 2,
        }
    );

    is $item1->equals($item2), 1, 'right equals';
    is $item1->equals($item3), 0, 'right not equals';
    is $item2->equals($item1), 1, 'right equals';
    is $item2->equals($item3), 0, 'right not equals';
};

subtest 'subtotal' => sub {
    my $item = Yetie::Domain::Entity::LineItem->new(
        {
            quantity => 2,
            price    => 300,
        }
    );
    is $item->subtotal, 600, 'right subtotal';
};

done_testing();
