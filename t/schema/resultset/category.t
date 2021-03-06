use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;
use Test::Exception;

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
        dies_ok { $rs->has_title() } 'right argument empty';

        ok $rs->has_title('foo'), 'right has title';
        ok !$rs->has_title('bar'), 'right has not title';
        ok !$rs->has_title( 'foo', $parent_id ), 'right has not title';
        ok $rs->has_title( 'bar', $parent_id ), 'right has title';
    };
};

subtest 'update_category' => sub {
    my $entity = Mojo::Base->new( id => 3, title => 'foo' );
    $entity->attr( [qw(id title)] );
    $rs->update_category( $entity, [] );

    my $result = $rs->find(3);
    is $result->title, 'foo', 'right updated title';
};

done_testing();
