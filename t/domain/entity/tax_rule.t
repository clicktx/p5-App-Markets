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

subtest 'caluculate_tax' => sub {
    my $rule = $pkg->new( tax_rate => 0.1 );

    my $price = Yetie::Domain::Value::Price->new(100);
    is $rule->caluculate_tax($price), '$10.00', 'right outside tax';

    $price = Yetie::Domain::Value::Price->new( value => 110, is_tax_included => 1 );
    is $rule->caluculate_tax($price), '$10.00', 'right inside tax';

    $price = Yetie::Domain::Value::Price->new( value => 0, is_tax_included => 1 );
    is $rule->caluculate_tax($price), '$0.00', 'right inside tax for zero';
};

subtest 'tax_rate_percentage' => sub {
    is Yetie::Domain::Entity::TaxRule->new( tax_rate => 0.08 )->tax_rate_percentage,    '8',    'right percentage';
    is Yetie::Domain::Entity::TaxRule->new( tax_rate => 0.03150 )->tax_rate_percentage, '3.15', 'right percentage';
};

done_testing();
