use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Factory';
use_ok 'Yetie::Factory::Entity::Cart';

subtest 'argument empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    isa_ok $e->items, 'Yetie::Domain::List::LineItems';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new('entity-cart')->construct();
    is $e->items->size, 0;
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        'entity-cart',
        {
            items => [ {}, {} ],
        }
    )->construct();
    isa_ok $e->items->first, 'Yetie::Domain::Entity::LineItem';
    is $e->items->size, 2, 'right items size';
};

done_testing;
