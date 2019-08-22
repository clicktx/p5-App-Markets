use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use DateTime;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('CommonTaxRule');

subtest 'find_by_dt' => sub {
    my $dt = DateTime->new(
        year  => 1990,
        month => 4,
        day   => 1,
    );
    my $result = $rs->find_by_dt($dt);
    isa_ok $result, 'Yetie::Schema::Result::CommonTaxRule';

    $dt = DateTime->new(
        year  => 1900,
        month => 4,
        day   => 1,
    );
    $result = $rs->find_by_dt($dt);
    is $result, undef, 'right not find';
};

done_testing();
