use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Factory';
use_ok 'Yetie::Domain::Factory::Entity::Cart';

subtest 'argument empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    isa_ok $e->billing_address, 'Yetie::Domain::Entity::Address';
    isa_ok $e->items,           'Yetie::Domain::Collection';
    isa_ok $e->shipments,       'Yetie::Domain::Collection';
    $e->shipments->each(
        sub {
            isa_ok $_->shipping_address, 'Yetie::Domain::Entity::Address';
            isa_ok $_->items,            'Yetie::Domain::Collection';
        }
    );
};

subtest 'shipments empty hash ref' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [] } )->construct();
    $e->shipments->each(
        sub {
            isa_ok $_->shipping_address, 'Yetie::Domain::Entity::Address';
            isa_ok $_->items,            'Yetie::Domain::Collection';
        }
    );
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    is $e->items->size, 0;
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        'entity-cart',
        {
            items => [ {} ],
        }
    )->construct();
    isa_ok $e->items->first, 'Yetie::Domain::Entity::Cart::Item';
};

subtest 'argument shipments data only' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [ { items => [ {}, {} ] } ] }, )->construct();
    $e->shipments->first->items->each(
        sub {
            isa_ok $_, 'Yetie::Domain::Entity::Cart::Item';
        }
    );
};

done_testing;
