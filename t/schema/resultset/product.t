use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('Product');

subtest 'find_product' => sub {
    my $result = $rs->find_product(1);
    is $result->title, 'test product1', 'right title';

    isa_ok $result, 'Yetie::Schema::Result::Product';
    isa_ok $result->created_at,         'DateTime';
    isa_ok $result->product_categories, 'Yetie::Schema::ResultSet::ProductCategory';
    isa_ok $result->product_categories->first->category, 'Yetie::Schema::Result::Category';
};

subtest 'update_product_categories' => sub {
    my $product_id          = 1;
    my @product_categories  = ( 1, 2, 3 );
    my $primary_category_id = 2;

    my $product = $rs->update_product_categories( $product_id, \@product_categories, $primary_category_id );
    my $itr = $product->product_categories;
    foreach my $id (@product_categories) {
        my $row = $itr->next;
        is $row->category_id, $id, 'right category_id';
        is $row->is_primary, 1, 'right is_primary' if $id == 2;
    }

    # Revert
    $rs->update_product_categories( $product_id, \@product_categories, 3 );
};

done_testing();
