use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Yetie::Schema::ResultSet::AddressState';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('AddressState');

subtest 'get_id' => sub {

    my $state_id = $rs->get_id( country_code => 'JP', state_code => '10' );
    is $state_id, '10', 'right state id';

    $state_id = $rs->get_id( country_code => 'US', state_code => 'CA' );
    is $state_id, '53', 'right state id';
};

done_testing();
