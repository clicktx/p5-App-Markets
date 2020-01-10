use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('shipping') );
}

ok 1;

use_ok 'Yetie::Service::Shipping';

subtest 'get_shipping_fee' => sub {
    my ( $c, $s ) = _init();

    my $sales_order = $c->factory('entity-sales_order')->construct(
        shipping_address => {
            id    => 1,
            state => 'SC',
        },
    );
    my $fee = $s->get_shipping_fee($sales_order);

    use DDP;
    p $sales_order->shipping_address;
    p $fee;
    ok 1;
};

# subtest 'get_rule' => sub {
#     my ( $c, $s ) = _init();

#     my $r = $s->get_rule;
#     is $r->id, 3, 'right tax rule ID now';
#     ok $r->tax_rate == 5, 'right tax rate now';

#     $r = $s->get_rule('2100-10-25');
#     is $r->id, 6, 'right tax rule ID';
#     ok $r->tax_rate == 10, 'right tax rate';
# };

done_testing();

__END__
