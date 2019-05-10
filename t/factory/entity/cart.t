use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Factory';
use_ok 'Yetie::Factory::Entity::Cart';

subtest 'argument empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    isa_ok $e->billing_address, 'Yetie::Domain::Entity::Address';
    isa_ok $e->items,           'Yetie::Domain::List::LineItems';
    isa_ok $e->shipments,       'Yetie::Domain::List::Shipments';
    $e->shipments->each(
        sub {
            isa_ok $_->shipping_address, 'Yetie::Domain::Entity::Address';
            isa_ok $_->items,            'Yetie::Domain::List::LineItems';
        }
    );
};

subtest 'shipments empty hash ref' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [] } )->construct();
    is_deeply $e->shipments->list->to_data, [], 'right empty';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    is $e->items->count, 0;
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        'entity-cart',
        {
            items => [ {} ],
        }
    )->construct();
    isa_ok $e->items->first, 'Yetie::Domain::Entity::LineItem';
};

subtest 'argument shipments data only' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [ { items => [ {}, {} ] } ] }, )->construct();
    $e->shipments->first->items->each(
        sub {
            isa_ok $_, 'Yetie::Domain::Entity::LineItem';
        }
    );
};

done_testing;
