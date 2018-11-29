use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::CartItem';

subtest 'basic' => sub {
    my $item = Yetie::Domain::Entity::CartItem->new(
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
    is $item->is_modified,   0,              'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';

    my $item2 = Yetie::Domain::Entity::CartItem->new(
        {
            product_id => 110,
            quantity   => 1,
        }
    );

    is $item->equals($item),  1, 'right equals item';
    is $item->equals($item2), 0, 'right not equals item';
};

subtest 'hash_code' => sub {
    my $item = Yetie::Domain::Entity::CartItem->new(
        {
            product_id => 111,
        }
    );
    is $item->hash_code, '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right hash code';
    is $item->is_modified, 0, 'right not modified';
};

subtest 'to_data' => sub {
    my $item = Yetie::Domain::Entity::CartItem->new(
        {
            hash       => 'foobar',
            product_id => 110,
            quantity   => 1,
        }
    );
    is_deeply $item->to_data,
      {
        product_id => 110,
        quantity   => 1,
      },
      'right dump data';
};

done_testing();
