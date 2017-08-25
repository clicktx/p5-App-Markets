use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;

subtest 'update_product_categories' => sub {
    my $rs = $schema->resultset('Product');

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
};

done_testing();
