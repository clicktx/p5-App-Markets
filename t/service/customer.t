package t::service::customer;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01 : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/test/find_customer')->status_is(200);
    $t->get_ok('/test/get_addresses')->status_is(200);
}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;
use Test::Deep;

sub find_customer {
    my $c = shift;
    my $s = $c->service('customer');

    subtest 'find_customer' => sub {
        my $entity = $s->find_customer('foo@bar.baz');
        isa_ok $entity, 'Yetie::Domain::Entity::Customer';
        is $entity->id, undef, 'right nonexists';

        $entity = $s->find_customer('a@example.org');
        is $entity->id, 111, 'right customer';
    };
    $c->render( text => 1 );
}

sub get_addresses {
    my $c = shift;
    my $s = $c->service('customer');

    subtest 'get_addresses' => sub {
        my $e = $s->get_addresses( 111, 'shipping_address' );
        isa_ok $e, 'Yetie::Domain::List::Addresses';
        is $e->list->size, 2, 'right shipping addresses';

        $e = $s->get_addresses( 111, 'billing_address' );
        is $e->list->size, 1, 'right billing addresses';

        $e = $s->get_addresses( 111, 'foo' );
        is $e->list->size, 0, 'right bad address type name';
    };
    $c->render( text => 1 );
}

done_testing();
