use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Activity');

subtest 'add_activity' => sub {
    my $e = $app->factory('entity-activity')->construct(
        {
            name           => 'foo',
            action         => 'bar',
            remote_address => '1.1.1.1',
            user_agent     => 'baz',
            customer_id    => 111,
        }
    );

    my $total            = $rs->count;
    my $c_rs             = $schema->resultset('Customer::Activity');
    my $c_activity_total = $c_rs->count;

    my $r = $rs->add_activity($e);
    isa_ok $r, 'Yetie::Schema::Result::Activity';

    $rs->add_activity($e);
    is $rs->last_id, $total + 2,            'right add data';
    is $c_rs->count, $c_activity_total + 2, 'right add data';
};

done_testing();
