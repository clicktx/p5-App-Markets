use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;
use Yetie::Domain::Value::Price;
use Yetie::Domain::Value::Tax;

my $pkg = 'Yetie::Domain::Entity::TotalAmount';
use_ok $pkg;

subtest 'basic' => sub {
    my $total = $pkg->new();
    can_ok $total, 'tax_rate';
    can_ok $total, 'tax';
    can_ok $total, 'total_excl_tax';
    can_ok $total, 'total_incl_tax';
};

done_testing();
