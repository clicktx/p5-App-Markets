use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::Shipping';

sub factory {
    return Yetie::Factory->new('entity-shipping')->construct(@_);
}

subtest 'basic' => sub {
    my $ship = factory(
        fee => {
            value         => 100,
            currency_code => 'USD',
            round_mode    => 'even',
        },
        tax_rule => {
            id       => 1,
            tax_rate => 5,
        },
    );

    isa_ok $ship->fee,      'Yetie::Domain::Value::Price';
    isa_ok $ship->tax_rule, 'Yetie::Domain::Entity::TaxRule';
};

done_testing();
