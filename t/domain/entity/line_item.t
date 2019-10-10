use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

sub factory {
    return Yetie::Factory->new('entity-line_item')->construct(@_);
}

use_ok 'Yetie::Domain::Entity::LineItem';

subtest 'basic' => sub {
    my $item = factory(
        {
            id            => 2,
            product_id    => 111,
            product_title => 'test product',
            quantity      => 1,
            price         => 100,
        }
    );

    is $item->id,            2,              'right id';
    is $item->product_id,    111,            'right product_id';
    is $item->product_title, 'test product', 'right product_title';
    is $item->quantity,      1,              'right quantity';
    is $item->price,         '$100.00',      'right price';
    is $item->is_modified,   0,              'right default modified';

    $item->product_id(111);
    is $item->is_modified, 0, 'right not modified';

    $item->quantity(5);
    is $item->is_modified, 1, 'right modified';

    dies_ok {
        factory(
            {
                id            => 2,
                product_id    => 0,
                product_title => 'test product',
                quantity      => 1,
                price         => 100,
            }
          )
    }
    'right isa product_id';
};

subtest 'equals' => sub {
    my $item1 = factory(
        {
            product_id => 1,
        }
    );
    my $item2 = factory(
        {
            product_id => 1,
        }
    );
    my $item3 = factory(
        {
            product_id => 2,
        }
    );

    is $item1->equals($item2), 1, 'right equals';
    is $item1->equals($item3), 0, 'right not equals';
    is $item2->equals($item1), 1, 'right equals';
    is $item2->equals($item3), 0, 'right not equals';
};

subtest 'product_hash_code' => sub {
    my $item = factory(
        {
            product_id => 111,
        }
    );
    is $item->product_hash_code, '6216f8a75fd5bb3d5f22b6f9958cdede3fc086c2', 'right hash code';
    is $item->is_modified, 0, 'right not modified';
};

subtest 'row_tax_amount' => sub {
    my $item = factory(
        {
            price    => 1,
            quantity => 5,
            tax_rule => {
                tax_rate => 3.5,
            },
        }
    );
    my $tax = $item->row_tax_amount;
    isa_ok $tax, 'Yetie::Domain::Value::Tax';
    is $tax, '$0.20', 'right tax amount';
};

subtest 'row_total' => sub {
    my $item = factory(
        {
            price    => 300,
            quantity => 0,
            tax_rule => {
                tax_rate => 5,
            },
        }
    );
    is $item->row_total_excl_tax, '$0.00', 'right row total excluding tax(no quantity)';
    is $item->row_total_incl_tax, '$0.00', 'right row total including tax(no quantity)';

    $item = factory(
        {
            price    => 300,
            quantity => 2,
            tax_rule => {
                tax_rate => 5,
            },
        }
    );
    is $item->row_total_excl_tax, '$600.00', 'right row total excluding tax';
    is $item->row_total_incl_tax, '$630.00', 'right row total including tax';
};

subtest 'to_data' => sub {
    my $item = factory(
        {
            product_id => 110,
            quantity   => 1,
        }
    );
    cmp_deeply $item->to_data,
      {
        product_id => 110,
        quantity   => 1,
        price      => ignore(),
        tax_rule   => ignore(),
      },
      'right dump data';
};

done_testing();
