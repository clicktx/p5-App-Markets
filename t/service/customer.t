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

    $entity = $s->find_customer('a@example.org');
    is $entity->id, 111, 'right customer';
};

subtest 'get_addresses' => sub {
    my ( $c, $s ) = _init();

    my $e = $s->get_addresses( 111, 'shipping' );
    isa_ok $e, 'Yetie::Domain::List::Addresses';
    is $e->list->size, 2, 'right shipping addresses';

    $e = $s->get_addresses( 111, 'billing' );
    is $e->list->size, 1, 'right billing addresses';

    $e = $s->get_addresses( 111, 'foo' );
    is $e->list->size, 0, 'right bad address type name';
};

done_testing();
