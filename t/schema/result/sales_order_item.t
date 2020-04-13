use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('SalesOrderItem');

subtest 'to_data' => sub {
    my $res = $rs->find(1001);
    cmp_deeply $res->to_data,
      {
        id            => 1001,
        product_id    => ignore(),
        product_title => ignore(),
        quantity      => ignore(),
        note          => ignore(),
        tax_rule      => ignore(),
        price         => {
            id              => ignore(),
            value           => ignore(),
            currency_code   => ignore(),
            is_tax_included => ignore(),
        },
      },
      'right data';
};

done_testing();
