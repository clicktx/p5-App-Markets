use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::LineItems';
use_ok $pkg;

my $construct = sub { Yetie::Factory->new('list-line_items')->construct(@_) };

subtest 'basic' => sub {
    my $list = $construct->();
    isa_ok $list, 'Yetie::Domain::List';
};

subtest 'append' => sub {
    my $f = Yetie::Factory->new('entity-line_item');
    my $data = [ { product_id => 1, quantity => 1 }, { product_id => 2, quantity => 2 } ];
    my ( $list, $item );

    # Append single
    $list = $construct->( list => $data );
    $item = $f->construct( { product_id => 3, quantity => 3 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 1, product_title => ignore(), price => ignore() },
        { product_id => 2, quantity => 2, product_title => ignore(), price => ignore() },
        { product_id => 3, quantity => 3, product_title => ignore(), price => ignore() }
      ],
      'right single append';
    is $list->is_modified, 1, 'right modified';

    # Append same item(update quantity)
    $list = $construct->( list => $data );
    $item = $f->construct( { product_id => 2, quantity => 2 } );
    $list->append($item);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 1, product_title => ignore(), price => ignore() },
        { product_id => 2, quantity => 4, product_title => ignore(), price => ignore() }
      ],
      'right sum quantity';
    is $list->is_modified, 1, 'right modified';

    # Append multi
    $list = $construct->( list => $data );
    $item = $f->construct( { product_id => 1, quantity => 1 } );
    my $item2 = $f->construct( { product_id => 2, quantity => 2 } );
    my $item3 = $f->construct( { product_id => 3, quantity => 3 } );
    $list->append( $item, $item2, $item3 );
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => 2, product_title => ignore(), price => ignore() },
        { product_id => 2, quantity => 4, product_title => ignore(), price => ignore() },
        { product_id => 3, quantity => 3, product_title => ignore(), price => ignore() }
      ],
      'right multi append';
    is $list->is_modified, 1, 'right modified';
};

subtest 'total_quantity' => sub {
    my $list = $construct->( list => [ { quantity => 1 }, { quantity => 2 } ] );
    is $list->total_quantity, 3, 'right total quantity';
};

subtest 'remove' => sub {
    my $data = [ { product_id => 1 }, { product_id => 2 }, { product_id => 3 } ];
    my $list = $construct->( list => $data );
    my $res = $list->remove(2);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => ignore(), product_title => ignore(), price => ignore() },
        { product_id => 3, quantity => ignore(), product_title => ignore(), price => ignore() }
      ],
      'right remove item';
    is $list->is_modified, 1, 'right modified';
    is $res, 1, 'right removed';

    # Unremove. not found item.
    $list = $construct->( list => $data );
    $res = $list->remove(4);
    cmp_deeply $list->to_data,
      [
        { product_id => 1, quantity => ignore(), product_title => ignore(), price => ignore() },
        { product_id => 2, quantity => ignore(), product_title => ignore(), price => ignore() },
        { product_id => 3, quantity => ignore(), product_title => ignore(), price => ignore() }
      ],
      'right not remove item';
    is $list->is_modified, 0, 'right not modified';
    is $res, 0, 'right not removed';
};

subtest 'subtotal' => sub {
    my $data = [ { quantity => 1, price => 1 }, { quantity => 2, price => 2 }, { quantity => 3, price => 3 } ];
    my $list = $construct->( list => $data );
    is $list->subtotal, 14, 'right subtotal';
};

done_testing();
