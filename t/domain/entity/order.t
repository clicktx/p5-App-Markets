use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Order';

subtest 'default attributes' => sub {
    my $o = Yetie::Domain::Entity::Order->new();
    isa_ok $o->customer,         'Yetie::Domain::Entity::Customer',     'right customer';
    isa_ok $o->billing_address,  'Yetie::Domain::Entity::Address',      'right billing_address';
    isa_ok $o->shipping_address, 'Yetie::Domain::Entity::Address',      'right shipping_address';
    isa_ok $o->items,            'Yetie::Domain::Entity::Order::Items', 'right items';
};

done_testing();
