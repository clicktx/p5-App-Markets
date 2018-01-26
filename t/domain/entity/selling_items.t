use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

use_ok 'Yetie::Domain::Entity::SellingItem';
use_ok 'Yetie::Domain::Entity::SellingItems';

subtest 'basic' => sub {
    my $items = Yetie::Domain::Entity::SellingItems->new();
    isa_ok $items->item_list, 'Yetie::Domain::Collection';
};

subtest 'total_amount()' => sub {
    my $item_list = c(
        Yetie::Domain::Entity::SellingItem->new(
            {
                quantity => 2,
                price    => 100,
            }
        ),
        Yetie::Domain::Entity::SellingItem->new(
            {
                quantity => 3,
                price    => 200,
            }
        ),
    );

    my $items = Yetie::Domain::Entity::SellingItems->new( { item_list => $item_list } );
    is $items->total_amount, 800, 'right total_amount';
};

done_testing();
