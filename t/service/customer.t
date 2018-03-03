use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('customer');
    return ( $controller, $service );
}

subtest 'find_customer' => sub {
    my ( $c, $s ) = _init();

    my $entity = $s->find_customer('foo@bar.baz');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, undef, 'right nonexists';

    $entity = $s->find_customer('a@x.org');
    is $entity->id, 111, 'right customer';
};

done_testing();
