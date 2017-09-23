use Mojo::Base -strict;
use Test::More;
use Markets::Domain::Factory;

my $test_data = {
    title            => 'product title',
    description      => 'product description',
    price            => 999,
    primary_category => [
        { id => 2,  level => 0, root_id => 2, title => "Fashion" },
        { id => 5,  level => 1, root_id => 2, title => "Women" },
        { id => 10, level => 2, root_id => 2, title => "Clothing" },
        { id => 11, level => 3, root_id => 2, title => "Dresses" },
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
    Markets::Domain::Factory->factory('entity-product')->create($test_data);
}

use_ok 'Markets::Domain::Entity::Product';

subtest 'basic' => sub {
    my $e = Markets::Domain::Entity::Product->new();
    isa_ok $e, 'Markets::Domain::Entity';

    can_ok $e, 'title';
    can_ok $e, 'description';
    can_ok $e, 'price';
    can_ok $e, 'primary_category';
    can_ok $e, 'product_categories';
    can_ok $e, 'created_at';
    can_ok $e, 'updated_at';
};

subtest 'primary_category' => sub {
    my $e = _create_entity();

    my $attr = $e->primary_category;
    isa_ok $attr, 'Markets::Domain::Collection';
    is @{$attr}, 5, 'right elements';
    isa_ok $attr->[0], 'Markets::Domain::Entity::Category';
};

subtest 'product_categories' => sub {
    my $e = _create_entity();

    my $attr = $e->product_categories;
    isa_ok $attr, 'Markets::Domain::Collection';
    is @{$attr}, 3, 'right elements';
    isa_ok $attr->[0], 'Markets::Domain::Entity::Product::Category';
};

done_testing();
