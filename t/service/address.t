use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('address');
    return ( $controller, $service );
}

my %params = (
    id            => 1,
    country_code  => 'US',
    line1         => '42 Pendergast St.',
    line2         => '',
    city          => 'Piedmont',
    state         => 'SC',
    postal_code   => '29673',
    personal_name => 'Elizabeth T. Peoples',
    organization  => 'Eli Moore Inc',
    phone         => '3059398498'
);

subtest 'get_choices_address_states' => sub {
    my ( $c, $s ) = _init();

    my $choices = $s->get_choices_address_states('JP');
    is @{$choices}, '47', 'right count array';
    is_deeply $choices->[-1], [ Okinawa => '47' ], 'right last element';
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

subtest 'set_address_id' => sub {
    my ( $c, $s ) = _init();
    my %data = (
        country_code  => 'us',
        line1         => '42 Pendergast St.',
        line2         => '',
        city          => 'Piedmont',
        state         => 'SC',
        postal_code   => '12345',
        personal_name => 'foo bar',
        organization  => '',
        phone         => '0011223344',
    );

    my $last_id    = $c->resultset('Address')->last_id;
    my $address    = $c->factory('entity-address')->construct(%data);
    my $address_id = $s->set_address_id($address);
    is $address_id, $last_id + 1, 'right store to storage';

    $address    = $c->factory('entity-address')->construct(%data);
    $address_id = $s->set_address_id($address);
    is $address_id, $last_id + 1, 'right load from storage';
};

subtest 'update_address' => sub {
    my ( $c, $s ) = _init();

    subtest 'exception' => sub {
        my %p = %params;
        $p{id} = 2;
        dies_ok { $s->update_address( \%p ) } 'right exception';
    };

    subtest 'do update' => sub {
        my %p = %params;
        $p{personal_name} = 'Eli za beth T. Peoples';
        $s->update_address( \%p );
        my $res = $c->schema->resultset('Address')->find( $p{id} );
        is $res->personal_name, $p{personal_name}, 'right update minor chages';

        # Revert DB data
        $s->update_address( \%params );
    };
};

done_testing();
