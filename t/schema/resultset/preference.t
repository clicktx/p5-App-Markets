use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Preference');

subtest 'to_data' => sub {
    my $data = $rs->search( {} )->to_data;
    cmp_deeply $data->[0], { admin_uri_prefix => ignore() }, 'right to_data';
};

done_testing();
