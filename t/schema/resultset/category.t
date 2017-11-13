use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Category');

subtest 'create_category' => sub {
    my $result;

    # Create root
    $result = $rs->create_category('foo');
    isa_ok $result, 'Yetie::Schema::Result::Category';
    my $parent_id = $result->id;

    # Create children
    $result = $rs->create_category( 'bar', $parent_id );
    isa_ok $result, 'Yetie::Schema::Result::Category';
    is $result->root_id, $parent_id, 'right child node';

    # Argument empty
    $result = $rs->create_category();
    is $result, undef, 'right argument empty';

    # Not found parent
    $result = $rs->create_category( 'buzz', 999 );
    is $result, undef, 'right not found parent';

    subtest 'has_title' => sub {
        eval { $rs->has_title() };
        ok $@, 'right argument empty';

        ok $rs->has_title('foo'), 'right has title';
        ok !$rs->has_title('bar'), 'right has not title';
        ok !$rs->has_title( 'foo', $parent_id ), 'right has not title';
        ok $rs->has_title( 'bar', $parent_id ), 'right has title';
    };
};

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
