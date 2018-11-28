use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'find_category' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category');
    my $form    = $c->form('search');

    my $e = $service->find_category( 1, $form );
    isa_ok $e, 'Yetie::Domain::Entity::Page::Category';
    is $e->id,    1,        'right ID';
    is $e->title, 'Sports', 'right title';
    isa_ok $e->form,        'Yetie::Form::Base';
    isa_ok $e->breadcrumbs, 'Yetie::Domain::List::Breadcrumbs';

    $e = $service->find_category( 999, $form );
    is $e->id, undef, 'right not found category';
};

subtest 'find_category_with_products' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category');
    my $form    = $c->form('search');
    $form->do_validate;

    my $e = $service->find_category_with_products( 1, $form );
    isa_ok $e, 'Yetie::Domain::Entity::Page::Category';
    is $e->id,    1,        'right ID';
    is $e->title, 'Sports', 'right title';
    isa_ok $e->form,        'Yetie::Form::Base';
    isa_ok $e->breadcrumbs, 'Yetie::Domain::List::Breadcrumbs';
    isa_ok $e->products,    'Yetie::Domain::List::Products';
    isa_ok $e->pager,       'DBIx::Class::ResultSet::Pager';

    $e = $service->find_category_with_products( 999, $form );
    is $e->id, undef, 'right not found category';
};

done_testing();

__END__
