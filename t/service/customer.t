package t::service::customer;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub _init {
    my $self       = shift;
    my $controller = $self->app->build_controller;
    my $service    = $controller->service('customer');
    return ( $controller, $service );
}

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01 : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/test/add_to_address_book')->status_is(200);

    subtest login_process_remember_me => sub {

        # right not argument
        $t->get_ok('/test/login_process_remember_me?token=')->status_is(200)->json_is( { customer_id => undef } );

        # right bad token
        $t->get_ok('/test/login_process_remember_me?token=foo-bar-baz')->status_is(200)
          ->json_is( { customer_id => undef } );

        # right login
        my $token = $self->app->service('authentication')->create_token( 'c@example.org', { action => 'foo' } );
        $t->get_ok( '/test/login_process_remember_me?token=' . $token->value )->status_is(200)
          ->json_is( { customer_id => 111 } );
    };

    subtest login_process_with_password => sub {
        my %csrf = ( csrf_token => $self->csrf_token );

        # right not argument
        $t->post_ok( '/test/login_process_with_password', form => { %csrf, email => '', password => '' } )
          ->status_is(401)->json_is( { customer_id => undef } );

        # right not found customer
        $t->post_ok( '/test/login_process_with_password',
            form => { %csrf, email => 'foo-bar@baz.com', password => '11111111' } )->status_is(401)
          ->json_is( { customer_id => undef } );

        # right password failure
        $t->post_ok( '/test/login_process_with_password',
            form => { %csrf, email => 'c@example.org', password => '11111111' } )->json_is( { customer_id => undef } );

        # right accept password
        $t->post_ok( '/test/login_process_with_password',
            form => { %csrf, email => 'c@example.org', password => '12345678' } )->status_is(200)
          ->json_is( { customer_id => 111 } );
    };
}

sub t02_create_customer : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $new_customer = $s->create_customer('new_customer_on_service@example.com');
    isa_ok $new_customer, 'Yetie::Domain::Entity::Customer';
    ok $new_customer->id, 'right id';

    $new_customer = $s->create_customer('new_customer_on_service@example.com');
    is $new_customer, undef, 'right duplicated';
}

sub t03_find_customer : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $entity = $s->find_customer('a@example.org');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, 111, 'right customer';

    # Guest customer
    $entity = $s->find_customer('foo@bar.baz');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, undef, 'right nonexists';
    ok !$entity->is_member, 'right guest';
}

sub t04_find_or_create_customer : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $entity = $s->find_or_create_customer('a@example.org');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, 111, 'right find customer';

    my $last_cid = $c->resultset('Customer')->last_id;
    $entity = $s->find_or_create_customer('find_or_create_customer@foo.bar');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, $last_cid + 1, 'right create customer';
}

sub t05_get_address_list : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $e = $s->get_address_list(112);
    isa_ok $e, 'Yetie::Domain::List::Addresses';
    is $e->list->size, 1, 'right addresses';

    $e = $s->get_address_list(999);
    is $e->list->size, 0, 'right not found customer';
}

sub t06_get_customer_cart_id : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $cart_id = $s->get_customer_cart_id(111);
    is $cart_id, 't8e3acvxwu9y49aw34b43rtn52nff61vhbogx2vn', 'right cart id';

    $cart_id = $s->get_customer_cart_id(999);
    is $cart_id, undef, 'right not found customer';
}

sub t07_search_customers : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $form = $c->form('search');
    $form->do_validate;

    my ( $e, $pager ) = $s->search_customers($form);
    isa_ok $e,     'Yetie::Domain::List::Customers';
    isa_ok $pager, 'DBIx::Class::ResultSet::Pager';
}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;
use Test::Deep;

sub add_to_address_book {
    my $c = shift;
    my $s = $c->service('customer');

    subtest 'add_to_address_book' => sub {
        my $res = $s->add_to_address_book(1);
        ok !$res, 'right no data';

        $c->server_session->customer_id(113);
        $res = $s->add_to_address_book(1);
        ok $res, 'right store address';

        $res = $s->add_to_address_book(1);
        ok !$res, 'right stored address';
    };
    $c->render( text => 1 );
}

sub login_process_remember_me {
    my $c     = shift;
    my $token = $c->param('token');

    my $customer_id = $c->service('customer')->login_process_remember_me($token);
    $c->render( json => { customer_id => $customer_id } );
}

sub login_process_with_password {
    my $c = shift;
    my $f = $c->form('auth-login');
    $f->do_validate;

    my $customer_id = $c->service('customer')->login_process_with_password($f);
    $c->render( json => { customer_id => $customer_id } );
}

done_testing();
