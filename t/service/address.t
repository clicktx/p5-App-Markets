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

subtest 'get_address_types' => sub {
    my ( $c, $s ) = _init();

    is $c->cache('address_types'), undef, 'right uncached';

    my $types = $s->get_address_types;
    isa_ok $types, 'Yetie::Domain::Entity::AddressTypes';

    is $c->cache('address_types'), $types, 'right cached';
};

subtest 'get_registered_id' => sub {
    my ( $c, $s ) = _init();
    my %p = %params;

    my $address = $c->factory('entity-address')->construct(%p);
    my $id      = $s->get_registered_id($address);
    is $id, undef, 'right found registered, but self it';

    $p{personal_name} = 'Eli za beth T. Peoples';
    $address          = $c->factory('entity-address')->construct(%p);
    $id               = $s->get_registered_id($address);
    is $id, undef, 'right found registered, but self it(minor changes)';

    $p{personal_name} = 'Becky T. Peoples';
    $address          = $c->factory('entity-address')->construct(%p);
    $id               = $s->get_registered_id($address);
    is $id, undef, 'right not found registered';

    %p       = %params;
    $p{id}   = 2;
    $address = $c->factory('entity-address')->construct(%p);
    $id      = $s->get_registered_id($address);
    is $id, 1, 'right found registered';
};

subtest 'store' => sub {
    my ( $c, $s ) = _init();

    subtest 'exception' => sub {
        my %p = %params;
        $p{id} = 2;
        eval { $s->store( \%p ) };
        ok $@, 'right exception';
    };

    subtest 'do update' => sub {
        my %p = %params;
        $p{personal_name} = 'Eli za beth T. Peoples';
        $s->store( \%p );
        my $res = $c->schema->resultset('Address')->find( $p{id} );
        is $res->personal_name, $p{personal_name}, 'right update minor chages';

        # Revert DB data
        $s->store( \%params );
    };
};

done_testing();
