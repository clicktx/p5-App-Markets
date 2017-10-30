use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Category');

subtest 'get_ancestors_arrayref' => sub {
    my $array = $rs->get_ancestors_arrayref(1);
    is_deeply $array, [], 'right root category';

    $array = $rs->get_ancestors_arrayref(13);
    is_deeply $array,
      [
        {
            id      => 2,
            level   => 0,
            root_id => 2,
            title   => "Fashion"
        },
        {
            id      => 5,
            level   => 1,
            root_id => 2,
            title   => "Women"
        },
        {
            id      => 10,
            level   => 2,
            root_id => 2,
            title   => "Clothing"
        },
        {
            id      => 11,
            level   => 3,
            root_id => 2,
            title   => "Dresses"
        }
      ],
      'right has ancestors';

    $array = $rs->get_ancestors_arrayref(999);
    is_deeply $array, [], 'right not found';
};

done_testing();
