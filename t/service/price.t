use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('price') );
}

use_ok 'Yetie::Service::Price';

subtest 'create_new' => sub {
    my ( $c, $s ) = _init();

    my $p = $s->create_new;
    is $p->value,           0,     'right default';
    is $p->currency_code,   'USD', 'right default currency code';
    is $p->is_tax_included, 0,     'right default tax including';

    $p = $s->create_new(101);
    is $p->value, 101, 'right value';

    $p = $s->create_new( 105, { currency_code => 'JPY', is_tax_included => 1 } );
    is $p->value,           105,   'right value';
    is $p->currency_code,   'JPY', 'right option currency code';
    is $p->is_tax_included, 1,     'right option tax including';
};

done_testing();

__END__
