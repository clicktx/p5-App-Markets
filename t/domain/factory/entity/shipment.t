use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Factory';
use_ok 'Yetie::Domain::Factory::Entity::Shipment';

subtest 'argument empty' => sub {
    my $factory = $pkg->new('entity-shipment');
    my $e       = $factory->construct();

    isa_ok $e, 'Yetie::Domain::Entity::Shipment';
    isa_ok $e->shipping_address, 'Yetie::Domain::Entity::Address';
    isa_ok $e->items,            'Yetie::Domain::Collection';
};

subtest 'data' => sub {
    my $factory = $pkg->new(
        'entity-shipment',
        {
            shipping_address => { line1 => 'Silicon Valley' },
            items            => [       {} ],
        }
    );
    my $e = $factory->construct();
    is $e->shipping_address->line1, 'Silicon Valley', 'right data';
    isa_ok $e->items->first, 'Yetie::Domain::Entity::Cart::Item';
};

done_testing;
