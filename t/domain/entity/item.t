use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Item';
my $item = Markets::Domain::Entity::Item->new(
    {
        product_id => 111,
        quantity   => 1,
    }
);

is $item->product_id, 111,                                        'right product_id';
is $item->quantity,   1,                                          'right quantity';
is $item->hash_code,  '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right hash_code';

is $item->is_modified, 0, 'right default modified';
$item->product_id(111);
is $item->is_modified, 0, 'right not modified';
$item->quantity(5);
is $item->is_modified, 1, 'right modified';

my $item2 = Markets::Domain::Entity::Item->new(
    {
        product_id => 110,
        quantity   => 1,
    }
);

is $item->is_equal($item),  1, 'right equal item';
is $item->is_equal($item2), 0, 'right not equal item';

done_testing();
