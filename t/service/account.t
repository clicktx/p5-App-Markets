use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('account');
    return ( $controller, $service );
}

subtest 'generate_token' => sub {
    my ( $c, $s ) = _init();
    my $rs      = $c->resultset('AuthorizationRequest');
    my $last_id = $rs->last_id;

    my $r = qr/[0-9A-F]/;
    like $s->generate_token('foo@example.org'), qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right token';
    isnt $last_id, $rs->last_id, 'right store to DB';
};

done_testing();
