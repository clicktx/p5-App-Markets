use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::ProductCategories';
use_ok $pkg;

sub construct {
    Yetie::Factory->new('list-product_categories')->construct(@_);
}

subtest 'basic' => sub {
    my $categories = construct();
    isa_ok $categories, 'Yetie::Domain::List';
};

subtest 'primary_category' => sub {
    my $categories =
      construct( list => [ { category_id => 1 }, { category_id => 2, is_primary => 1 }, { category_id => 3 } ] );
    my $primary = $categories->primary_category;
    is $primary->category_id, 2, 'right primary category';
};

subtest 'get_form_choices_primary_category' => sub {
    my $categories =
      construct( list => [ { category_id => 1 }, { category_id => 2, is_primary => 1 }, { category_id => 3 } ] );
    my $choices = $categories->get_form_choices_primary_category;
    is_deeply $choices, [ [ q{}, 1 ], [ q{}, 2, choiced => 1 ], [ q{}, 3 ] ], 'right form primary choiced';
};

subtest 'get_id_list' => sub {
    my $categories =
      construct( list => [ { category_id => 1 }, { category_id => 2, is_primary => 1 }, { category_id => 3 } ] );
    my $list = $categories->get_id_list;
    is_deeply $list, [ 1, 2, 3 ], 'right list';

    $categories = construct();
    $list       = $categories->get_id_list;
    is_deeply $list, [], 'right list';
};

done_testing();
