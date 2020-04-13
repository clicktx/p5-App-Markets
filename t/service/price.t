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
    is $p->value,    0,     'right default';
    is $p->price_id, undef, 'right default price id';
    is $p->round_mode,      $app->pref('default_round_mode'),     'right default round mode';
    is $p->currency_code,   $app->pref('locale_currency_code'),   'right default currency code';
    is $p->is_tax_included, $app->pref('is_price_including_tax'), 'right default tax including';

    $p = $s->create_new(
        {
            value           => 105,
            id              => 222,
            round_mode      => 'zero',
            currency_code   => 'JPY',
            is_tax_included => 1
        }
    );
    is $p->value,           105,    'right value';
    is $p->price_id,        222,    'right price id';
    is $p->round_mode,      'zero', 'right round mode';
    is $p->currency_code,   'JPY',  'right option currency code';
    is $p->is_tax_included, 1,      'right option tax including';
};

done_testing();

__END__
