use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('tax') );
}

use_ok 'Yetie::Service::Tax';

subtest 'get_rule' => sub {
    my ( $c, $s ) = _init();

    my $r = $s->get_rule;
    is $r->id, 3, 'right tax rule ID now';
    ok $r->tax_rate == 5, 'right tax rate now';

    $r = $s->get_rule('2100-10-25');
    is $r->id, 6, 'right tax rule ID';
    ok $r->tax_rate == 10, 'right tax rate';
};

done_testing();

__END__
