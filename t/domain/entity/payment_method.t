use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $data = {
    id   => 111,
    name => 'foo',
};

sub _create_entity {
    Yetie::Factory->new('entity-payment_method')->construct(@_);
}

use_ok 'Yetie::Domain::Entity::PaymentMethod';

subtest 'basic' => sub {
    my $e = _create_entity($data);
    isa_ok $e, 'Yetie::Domain::Entity';
    is $e->name, 'foo', 'right name';
};

done_testing();
