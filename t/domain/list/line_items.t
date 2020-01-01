use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::LineItems';
use_ok $pkg;

sub factory {
    return Yetie::Factory->new('list-line_items')->construct(@_);
}

sub item_factory {
    return Yetie::Factory->new('entity-line_item')->construct(@_);
}

subtest 'basic' => sub {
    my $list = factory();
    isa_ok $list, 'Yetie::Domain::List';
};

subtest 'append' => sub {
    my $data = [ { id => 1, quantity => 1 }, { id => 2, quantity => 2 } ];
    my ( $list, $item );

    # Append single
    $list = factory( list => $data );
    $item = item_factory( { id => 3, quantity => 3 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { id => 1, quantity => 1, price => ignore(), tax_rule => ignore() },
        { id => 2, quantity => 2, price => ignore(), tax_rule => ignore() },
        { id => 3, quantity => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right single append';
    is $list->is_modified, 1, 'right modified';

    # Append same item(update quantity)
    $list = factory( list => $data );
    $item = item_factory( { id => 2, quantity => 2 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { id => 1, quantity => 1, price => ignore(), tax_rule => ignore() },
        { id => 2, quantity => 4, price => ignore(), tax_rule => ignore() }
      ],
      'right sum quantity';
    is $list->is_modified, 1, 'right modified';

    # Append multi
    $list = factory( list => $data );
    $item = item_factory( { id => 1, quantity => 1 } );
    my $item2 = item_factory( { id => 2, quantity => 2 } );
    my $item3 = item_factory( { id => 3, quantity => 3 } );
    $list->append( $item, $item2, $item3 );
    cmp_deeply $list->to_data,
      [
        { id => 1, quantity => 2, price => ignore(), tax_rule => ignore() },
        { id => 2, quantity => 4, price => ignore(), tax_rule => ignore() },
        { id => 3, quantity => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right multi append';
    is $list->is_modified, 1, 'right modified';
};

subtest 'total_quantity' => sub {
    my $list = factory( list => [ { quantity => 1 }, { quantity => 2 } ] );
    is $list->total_quantity, 3, 'right total quantity';
};

subtest 'remove' => sub {
    my $data = [ { id => 1 }, { id => 2 }, { id => 3 } ];
    my $list = factory( list => $data );
    my $res = $list->remove(2);
    cmp_deeply $list->to_data,
      [
        { id => 1, price => ignore(), tax_rule => ignore(), quantity => ignore() },
        { id => 3, price => ignore(), tax_rule => ignore(), quantity => ignore() },
      ],
      'right remove item';
    is $list->is_modified, 1, 'right modified';
    is $res, 1, 'right removed';

    # Unremove. not found item.
    $list = factory( list => $data );
    $res = $list->remove(4);
    cmp_deeply $list->to_data,
      [
        { id => 1, price => ignore(), tax_rule => ignore(), quantity => ignore() },
        { id => 2, price => ignore(), tax_rule => ignore(), quantity => ignore() },
        { id => 3, price => ignore(), tax_rule => ignore(), quantity => ignore() }
      ],
      'right not remove item';
    is $list->is_modified, 0, 'right not modified';
    is $res, 0, 'right not removed';
};

subtest 'subtotal' => sub {
    my $data = [
        {
            price    => 10,
            quantity => 1,
            tax_rule => {
                tax_rate => 5,
            },
        },
        {
            price    => 20,
            quantity => 2,
            tax_rule => {
                tax_rate => 3,
            },
        },
        {
            price    => 30,
            quantity => 3,
            tax_rule => {
                tax_rate => 5,
            },
        }
    ];
    my $list = factory( list => [] );
    is $list->subtotal_excl_tax, '$0.00', 'right subtotal excluding tax(no items)';
    is $list->subtotal_incl_tax, '$0.00', 'right subtotal including tax(no items)';

    $list = factory( list => $data );
    is $list->subtotal_excl_tax, '$140.00', 'right subtotal excluding tax';
    is $list->subtotal_incl_tax, '$146.20', 'right subtotal including tax';
};

done_testing();
