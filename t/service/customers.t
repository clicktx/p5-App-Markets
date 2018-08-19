use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('customers');
    return ( $controller, $service );
}

subtest 'search_customers' => sub {
    my ( $c, $s ) = _init();

    my $form = $c->form('search');
    $form->do_validate;

    my $e = $s->search_customers($form);
    isa_ok $e, 'Yetie::Domain::Entity::Page::Customers';
};

done_testing();
