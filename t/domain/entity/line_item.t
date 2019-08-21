use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

sub factory {
    return Yetie::Factory->new('entity-line_item')->construct(@_);
}

use_ok 'Yetie::Domain::Entity::LineItem';

subtest 'basic' => sub {
    my $item = factory(
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
    is $item->price,         '$100.00',      'right price';
    is $item->is_modified,   0,              'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';
};

subtest 'equals' => sub {
    my $item1 = factory(
        {
            product_id => 1,
        }
    );
    my $item2 = factory(
        {
            product_id => 1,
        }
    );
    my $item3 = factory(
        {
            product_id => 2,
        }
    );

    is $item1->equals($item2), 1, 'right equals';
    is $item1->equals($item3), 0, 'right not equals';
    is $item2->equals($item1), 1, 'right equals';
    is $item2->equals($item3), 0, 'right not equals';
};

subtest 'product_hash_code' => sub {
    my $item = factory(
        {
            product_id => 111,
        }
    );
    is $item->product_hash_code, '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right hash code';
    is $item->is_modified, 0, 'right not modified';
};

subtest 'subtotal' => sub {
    my $item = factory(
        {
            quantity => 2,
            price    => 300,
        }
    );
    is $item->subtotal, 600, 'right subtotal';
};

subtest 'to_data' => sub {
    my $item = factory(
        {
            product_id => 110,
            quantity   => 1,
        }
    );
    cmp_deeply $item->to_data,
      {
        product_id => 110,
        quantity   => 1,
        price      => ignore(),
        tax_rule   => ignore(),
      },
      'right dump data';
};

done_testing();
