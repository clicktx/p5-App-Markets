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
    my $list = construct();
    isa_ok $list, 'Yetie::Domain::List';
};

subtest 'primary_category' => sub {
    my $list =
      construct( list => [ { category_id => 1 }, { category_id => 2, is_primary => 1 }, { category_id => 3 } ] );
    my $primary = $list->primary_category;
    is $primary->category_id, 2, 'right primary category';
};

done_testing();
