use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

my %example_data = (
    items => [
        {
            product_id    => 1,
            product_title => 'a',
            quantity      => 1,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { tax_rate => 5 },
        },
        {
            product_id    => 2,
            product_title => 'b',
            quantity      => 2,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { tax_rate => 5 },
        },
        {
            product_id    => 3,
            product_title => 'c',
            quantity      => 3,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { tax_rate => 5 },
        },
    ],
);

sub _create_entity {
    my %args = @_;
    %args = %example_data unless @_;

    Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '12345',
            %args,
        }
    );
}

use_ok 'Yetie::Domain::Entity::Cart';
use_ok 'Yetie::Domain::Entity::LineItem';

subtest 'basic' => sub {
    my $cart = Yetie::Domain::Entity::Cart->new;
    ok $cart->id;
    isa_ok $cart->items, 'Yetie::Domain::List::LineItems';
};

subtest 'attributes' => sub {
    my $cart = _create_entity;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Yetie::Domain::List::LineItems', 'right items';
    isa_ok $cart->items->first, 'Yetie::Domain::Entity::LineItem', 'right items';
};

subtest 'methods' => sub {
    my $cart      = _create_entity;
    my $cart_data = $cart->to_data;
    my %d         = %example_data;
    my $d         = \%d;
    cmp_deeply $cart_data, { id => ignore(), cart_id => ignore(), %{$d} }, 'right data structure';
    is $cart->id,                '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->count_total_items, 3,                                          'right total total items';
    is $cart->total_quantity,    6,                                          'right total quantity';

    my $cart2 = Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '54321',
            %example_data,
        }
    );

    is $cart->equals($cart),  1, 'right equals entity';
    is $cart->equals($cart2), 0, 'right not equals entity';
};

subtest 'add_item' => sub {
    my $cart = _create_entity;
    $cart->add_item( Yetie::Factory->new('entity-line_item')->construct( product_id => 11 ) );
    is $cart->items->last->product_id, '11', 'right last item';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->add_item(
        Yetie::Factory->new('entity-line_item')->construct( product_id => 1, quantity => 1, price => 100 ) );
    is $cart->items->first->quantity, '2', 'right sum quantity';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clear_items' => sub {
    my $cart = _create_entity;
    $cart->clear_items;
    is $cart->items->size, 0;
    is $cart->count_total_items, 0;
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clone' => sub {
    my $cart = _create_entity;

    my $clone = $cart->clone;
    is $cart->is_modified,  0, 'right cart not modified';
    is $clone->is_modified, 0, 'right clone not modified';
    cmp_deeply $cart->to_data, $clone->to_data, 'right all data';

    # items
    isnt $cart->items->list->[0], $clone->items->list->[0], 'right cart reference';
    cmp_deeply $cart->items->list->[0]->to_data, $clone->items->list->[0]->to_data, 'right cart data';
};

subtest 'merge' => sub {
    my $cart        = _create_entity;
    my %stored_data = (
        items => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 1, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
        ],
    );
    my $stored_cart = Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '99999',
            %stored_data,
        }
    );

    my %d = %example_data;
    my $d = \%d;
    $d->{cart_id} = '12345';
    my $cart_data = $cart->to_data;
    cmp_deeply $cart_data, { id => ignore(), %{$d} }, 'right non-destructive';

    %d            = %stored_data;
    $d            = \%d;
    $d->{cart_id} = '99999';
    my $stored_cart_data = $stored_cart->to_data;
    cmp_deeply $stored_cart_data,
      {
        id      => ignore(),
        cart_id => '99999',
        items   => [
            {
                product_id => 4,
                quantity   => 4,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 1,
                quantity   => 1,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 5,
                quantity   => 5,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
        ],
      },
      'right stored';
    my $merged_cart      = $cart->merge($stored_cart);
    my $merged_cart_data = $merged_cart->to_data;

    cmp_deeply $merged_cart_data,
      {
        id      => ignore(),
        cart_id => '99999',
        items   => [
            {
                product_id => 4,
                quantity   => 4,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 1,
                quantity   => 2,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 5,
                quantity   => 5,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id    => 2,
                quantity      => 2,
                product_title => 'b',
                price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule      => ignore(),
            },
            {
                product_id    => 3,
                quantity      => 3,
                product_title => 'c',
                price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule      => ignore(),
            },
        ],
      },
      'right merge data';
    is $merged_cart->is_modified, 1, 'right modified';
};

subtest 'remove_item' => sub {
    my $cart = _create_entity;
    dies_ok { $cart->remove_item('foo'); } 'right argument srt';

    $cart->remove_item(2);
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{items},
      [
        {
            product_id    => 1,
            quantity      => 1,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right remove item';

    # Unremove. not found item.
    $cart = _create_entity;
    $cart->remove_item(4);
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{items},
      [
        {
            product_id    => 1,
            quantity      => 1,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 2,
            quantity      => 2,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right not removed';
};

# subtest 'grand_total' => sub {};

subtest 'subtotal' => sub {
    subtest 'excluding tax' => sub {
        my $cart = _create_entity;
        ok $cart->subtotal_excl_tax == 600, 'right subtotal excluding tax';

        # no items
        $cart = Yetie::Factory->new('entity-cart')->construct( cart_id => '12345' );
        ok $cart->subtotal_excl_tax == 0, 'right no items';
    };

    subtest 'including tax' => sub {
        my $cart = _create_entity;
        ok $cart->subtotal_incl_tax == 630, 'right subtotal including tax';

        # no items
        $cart = Yetie::Factory->new('entity-cart')->construct( cart_id => '12345' );
        ok $cart->subtotal_incl_tax == 0, 'right no items';
    };
};

done_testing();
