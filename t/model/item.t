use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Model::Item';
my $model = Markets::Model::Item->new;

my $items = [
    { ff => 3, bb => 5,  zz => 15 },
    { ff => 6, bb => 10, zz => 15 },
    { ff => 9, bb => 20, zz => 30 },
];

subtest 'item' => sub {

    my $array = $model->to_array(111, $items);
    is_deeply $array, [
        [qw/bb ff order_id zz/],
        [5, 3, 111, 15],
        [10, 6, 111, 15],
        [20, 9, 111, 30],
    ];
};

done_testing();
