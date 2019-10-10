use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Value::Price';

my $pkg = 'Yetie::Domain::Entity::TaxRule';
use_ok $pkg;

subtest 'basic' => sub {
    my $rule = $pkg->new();

    is $rule->tax_rate, 0, 'right default rate';
    can_ok $rule, 'title';
};

subtest 'tax_rate' => sub {
    is Yetie::Domain::Entity::TaxRule->new( tax_rate => 8.00 )->tax_rate, '8',    'right rate';
    is Yetie::Domain::Entity::TaxRule->new( tax_rate => 3.15 )->tax_rate, '3.15', 'right rate';
};

subtest 'caluculate_tax' => sub {
    my $rule = $pkg->new( tax_rate => 10.000 );

    my $price = Yetie::Domain::Value::Price->new(100);
    my $tax   = $rule->caluculate_tax($price);
    is $tax, '$10.00', 'right outside tax';
    isa_ok $tax, 'Yetie::Domain::Value::Tax';

    $price = Yetie::Domain::Value::Price->new( value => 110, is_tax_included => 1 );
    is $rule->caluculate_tax($price), '$10.00', 'right inside tax';

    $price = Yetie::Domain::Value::Price->new( value => 0, is_tax_included => 1 );
    is $rule->caluculate_tax($price), '$0.00', 'right inside tax for zero';

    $price = Yetie::Domain::Value::Price->new( value => 1, is_tax_included => 0 );
    $rule = $pkg->new( tax_rate => 3.5 );
    is $rule->caluculate_tax($price), '$0.04', 'right round mode even(default)';

    $rule = $pkg->new( tax_rate => 3.5, round_mode => 'trunc' );
    is $rule->caluculate_tax($price), '$0.03', 'right round mode trunc';
};

done_testing();
