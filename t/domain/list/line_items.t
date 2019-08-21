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
    my $data = [ { product_id => 1, quantity => 1 }, { product_id => 2, quantity => 2 } ];
    my ( $list, $item );

    # Append single
    $list = factory( list => $data );
    $item = item_factory( { product_id => 3, quantity => 3 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 1, price => ignore(), tax_rule => ignore() },
        { product_id => 2, quantity => 2, price => ignore(), tax_rule => ignore() },
        { product_id => 3, quantity => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right single append';
    is $list->is_modified, 1, 'right modified';

    # Append same item(update quantity)
    $list = factory( list => $data );
    $item = item_factory( { product_id => 2, quantity => 2 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 1, price => ignore(), tax_rule => ignore() },
        { product_id => 2, quantity => 4, price => ignore(), tax_rule => ignore() }
      ],
      'right sum quantity';
    is $list->is_modified, 1, 'right modified';

    # Append multi
    $list = factory( list => $data );
    $item = item_factory( { product_id => 1, quantity => 1 } );
    my $item2 = item_factory( { product_id => 2, quantity => 2 } );
    my $item3 = item_factory( { product_id => 3, quantity => 3 } );
    $list->append( $item, $item2, $item3 );
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 2, price => ignore(), tax_rule => ignore() },
        { product_id => 2, quantity => 4, price => ignore(), tax_rule => ignore() },
        { product_id => 3, quantity => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right multi append';
    is $list->is_modified, 1, 'right modified';
};

subtest 'total_quantity' => sub {
    my $list = factory( list => [ { quantity => 1 }, { quantity => 2 } ] );
    is $list->total_quantity, 3, 'right total quantity';
};

subtest 'remove' => sub {
    my $data = [ { product_id => 1 }, { product_id => 2 }, { product_id => 3 } ];
    my $list = factory( list => $data );
    my $res = $list->remove(2);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, price => ignore(), tax_rule => ignore() },
        { product_id => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right remove item';
    is $list->is_modified, 1, 'right modified';
    is $res, 1, 'right removed';

    # Unremove. not found item.
    $list = factory( list => $data );
    $res = $list->remove(4);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, price => ignore(), tax_rule => ignore() },
        { product_id => 2, price => ignore(), tax_rule => ignore() },
        { product_id => 3, price => ignore(), tax_rule => ignore() }
      ],
      'right not remove item';
    is $list->is_modified, 0, 'right not modified';
    is $res, 0, 'right not removed';
};

subtest 'subtotal' => sub {
    my $data = [ { quantity => 1, price => 1 }, { quantity => 2, price => 2 }, { quantity => 3, price => 3 } ];
    my $list = factory( list => $data );
    is $list->subtotal, 14, 'right subtotal';
};

done_testing();
