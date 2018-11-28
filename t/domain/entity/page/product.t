use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $test_data = {
    title       => 'product title',
    description => 'product description',
    price       => 999,
    breadcrumbs => [
        { id => 2,  title => "Fashion" },
        { id => 5,  title => "Women" },
        { id => 10, title => "Clothing" },
        { id => 11, title => "Dresses" },
        { id => 13, title => "Casual" }
    ],
    product_categories => [
        { category_id => 13, is_primary => 1, title => "Casual" },
        { category_id => 11, is_primary => 0, title => "Dresses" },
        { category_id => 1,  is_primary => 0, title => "Sports" },
    ],

    created_at => undef,
    updated_at => undef,
};

sub _create_entity {
    Yetie::Factory->new('entity-page-product')->construct($test_data);
}

use_ok 'Yetie::Domain::Entity::Page::Product';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::Page::Product->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'title';
    can_ok $e, 'description';
    can_ok $e, 'price';
    can_ok $e, 'product_categories';
    can_ok $e, 'created_at';
    can_ok $e, 'updated_at';
};

subtest 'breadcrumbs' => sub {
    my $e = _create_entity();

    my $attr = $e->breadcrumbs;
    isa_ok $attr, 'Yetie::Domain::List::Breadcrumbs';
    is $attr->list->size, 5, 'right elements';
    isa_ok $attr->first, 'Yetie::Domain::Entity::Breadcrumb';
};

subtest 'product_categories' => sub {
    my $e = _create_entity();

    my $attr = $e->product_categories;
    isa_ok $attr, 'Yetie::Domain::List::ProductCategories';
    is $attr->list->size, 3, 'right elements';
    isa_ok $attr->first, 'Yetie::Domain::Entity::ProductCategory';
};

done_testing();
