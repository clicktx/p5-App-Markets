use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('payment') );
}

use_ok 'Yetie::Service::Payment';

subtest 'get_payment_methods' => sub {
    my ( $c, $s ) = _init();

    my $payments = $s->get_payment_methods();
    isa_ok $payments, 'Yetie::Domain::List::PaymentMethods';
    is $payments->size, 4, 'right size';
    is $payments->list->[1]->id,   2;
    is $payments->list->[1]->name, 'Paypal';
};

done_testing();

__END__
