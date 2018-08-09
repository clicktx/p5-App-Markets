use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('address');
    return ( $controller, $service );
}

my %params = (
    id            => 1,
    country_code  => 'us',
    line1         => '42 Pendergast St.',
    line2         => '',
    city          => 'Piedmont',
    state         => 'SC',
    postal_code   => '29673',
    personal_name => 'Elizabeth T. Peoples',
    organization  => 'Eli Moore Inc',
    phone         => '3059398498'
);

subtest 'get registered id' => sub {
    my ( $c, $s ) = _init();
    my %p = %params;

    my $address = $c->factory('entity-address')->create(%p);
    my $id      = $s->get_registered_id($address);
    is $id, undef, 'right found registered, but self it';

    $p{personal_name} = 'Eli za beth T. Peoples';
    $address          = $c->factory('entity-address')->create(%p);
    $id               = $s->get_registered_id($address);
    is $id, undef, 'right found registered, but self it(minor changes)';

    $p{personal_name} = 'Becky T. Peoples';
    $address          = $c->factory('entity-address')->create(%p);
    $id               = $s->get_registered_id($address);
    is $id, undef, 'right not found registered';

    %p       = %params;
    $p{id}   = 2;
    $address = $c->factory('entity-address')->create(%p);
    $id      = $s->get_registered_id($address);
    is $id, 1, 'right found registered';
};

done_testing();
