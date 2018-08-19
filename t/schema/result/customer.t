use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Customer');

subtest 'to_data' => sub {
    my $res = $rs->find(111);
    ok $res->to_data, 'right registered customer';

    $res = $rs->find(115);
    my $data = $res->to_data;
    ok $data, 'right not registered customer';
    is $data->{password}, '', 'right password';
};

done_testing();
