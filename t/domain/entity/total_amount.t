use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::TotalAmount';
use_ok $pkg;

my $f = Yetie::Factory->new('entity-total_amount');

subtest 'basic' => sub {
    my $total = $pkg->new();
    can_ok $total, 'tax_rate';
    can_ok $total, 'tax';
    can_ok $total, 'total_excl_tax';
    can_ok $total, 'total_incl_tax';
};

subtest 'sum' => sub {
    my $total = $f->construct(
        tax_rate       => 3,
        tax            => $f->factory('value-tax')->construct(),
        total_excl_tax => $f->factory('value-price')->construct(),
        total_incl_tax => $f->factory('value-price')->construct( is_tax_included => 1 ),
    );

    my $line_item = $f->factory('entity-line_item')->construct(
        {
            tax_rule => {
                tax_rate => 5,
            },
        }
    );
    dies_ok { $total->sum($line_item) } 'right different tax rate';

    $line_item = $f->factory('entity-line_item')->construct(
        {
            quantity => 1,
            price    => 100,
            tax_rule => {
                tax_rate => 3,
            },
        }
    );
    my $new = $total->sum($line_item);
    is $new->tax,            '$3.00',   'right tax';
    is $new->total_excl_tax, '$100.00', 'right total excluding tax';
    is $new->total_incl_tax, '$103.00', 'right tax total including tax';
};

done_testing();
