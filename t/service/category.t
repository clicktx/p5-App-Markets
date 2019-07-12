use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('category');
    return ( $controller, $service );
}

### NOTE: Do this test first.
subtest 'get_category_tree' => sub {
    my ( $c, $s ) = _init();

    is $app->cache('category_tree'), undef, 'right not cached';

    my $tree = $s->get_category_tree();
    isa_ok $tree, 'Yetie::Domain::Entity::CategoryTreeRoot';
    isa_ok $app->cache('category_tree'), 'Yetie::Domain::Entity::CategoryTreeRoot', 'right cached';
};

subtest 'find_category' => sub {
    my ( $c, $s ) = _init();
    my $form = $c->form('search');

    my $e = $s->find_category( 1, $form );
    isa_ok $e, 'Yetie::Domain::Entity::Category';
    is $e->id,    1,        'right ID';
    is $e->title, 'Sports', 'right title';

    $e = $s->find_category( 999, $form );
    is $e->id, undef, 'right not found category';
};

subtest 'find_category_with_products' => sub {
    my ( $c, $s ) = _init();
    my $form = $c->form('search');
    $form->do_validate;

    my ( $e, $pager, $breadcrumbs ) = $s->find_category_with_products( 1, $form );
    isa_ok $e, 'Yetie::Domain::Entity::Category';
    is $e->id,    1,        'right ID';
    is $e->title, 'Sports', 'right title';
    isa_ok $e->products, 'Yetie::Domain::List::Products';

    isa_ok $pager,       'DBIx::Class::ResultSet::Pager';
    isa_ok $breadcrumbs, 'Yetie::Domain::List::Breadcrumbs';

    ( $e, $pager, $breadcrumbs ) = $s->find_category_with_products( 999, $form );
    is $e->id, undef, 'right not found category';
};

done_testing();

__END__
