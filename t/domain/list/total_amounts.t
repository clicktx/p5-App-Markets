use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::List::TotalAmounts';

my $f              = Yetie::Factory->new('list-total_amounts');
my $line_item_tax3 = $f->factory('entity-line_item')->construct(
    {
        quantity => 1,
        price    => 100,
        tax_rule => {
            tax_rate => 3,
        },
    }
);
my $line_item_tax5 = $f->factory('entity-line_item')->construct(
    {
        quantity => 1,
        price    => 100,
        tax_rule => {
            tax_rate => 5,
        },
    }
);

subtest 'sum' => sub {
    my $totals = $f->construct();
    $totals->sum($line_item_tax3);
    my $first = $totals->first;
    is $first->tax_rate,       3,         'right new tax rate';
    is $first->tax,            '$3.00',   'right new tax';
    is $first->total_excl_tax, '$100.00', 'right new total excluding tax';
    is $first->total_incl_tax, '$103.00', 'right new total including tax';

    $totals->sum($line_item_tax5);
    is $totals->size, 2, 'right size';
    $first = $totals->first;
    is $first->tax_rate,       5,         'right new tax rate';
    is $first->tax,            '$5.00',   'right new tax';
    is $first->total_excl_tax, '$100.00', 'right new total excluding tax';
    is $first->total_incl_tax, '$105.00', 'right new total including tax';

    $totals->sum($line_item_tax5);
    $first = $totals->first;
    is $first->tax_rate,       5,         'right tax rate';
    is $first->tax,            '$10.00',  'right total tax';
    is $first->total_excl_tax, '$200.00', 'right total excluding tax';
    is $first->total_incl_tax, '$210.00', 'right total including tax';

    my $grand_total = $totals->grand_total;
    isa_ok $grand_total, 'Yetie::Domain::Value::Price';
    is $grand_total, '$313.00', 'right grand total';
};

subtest 'grand_total' => sub {
    my $totals      = $f->construct();
    my $grand_total = $totals->grand_total;
    isa_ok $grand_total, 'Yetie::Domain::Value::Price';
    is $grand_total, '$0.00', 'right grand total';

    $totals->sum($line_item_tax5);
    $grand_total = $totals->grand_total;
    isa_ok $grand_total, 'Yetie::Domain::Value::Price';
    is $grand_total, '$105.00', 'right grand total';
};

done_testing();
