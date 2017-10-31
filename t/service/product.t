use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
use_ok 'Markets::Service::Product';

subtest 'duplicate_product' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');

    my $last_id = $app->schema->resultset('Product')->search( {}, { order_by => { -desc => 'id' } } )->first->id;
    my $product = $service->duplicate_product(1);
    is $product->id, $last_id + 1, 'right id';
    is $product->description,        'product description1', 'right description';
    is $product->price,              '100.00',               'right price';
    like $product->title,            qr/copy/,               'copy title';
    is $product->product_categories, 2,                      'right product_categories';

    my $e1 = $app->factory('product')->build(1)->to_data;
    my $e2 = $app->factory('product')->build( $product->id )->to_data;
    is $e1->{price},                     $e2->{price},              'right price';
    is $e1->{description},               $e2->{description},        'right description';
    is_deeply $e1->{product_categories}, $e2->{product_categories}, 'right product_categories';
};

subtest 'choices_primary_category' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');
    my $e       = $app->factory('product')->build(1);

    my $choices = $service->choices_primary_category($e);
    is ref $choices, 'ARRAY', 'right get array ref';

    my $int     = @{$choices};
    my @choices = $service->choices_primary_category($e);
    is @choices, $int, 'right get array';

};

subtest 'new_product' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');

    my $last_id = $app->schema->resultset('Product')->search( {}, { order_by => { -desc => 'id' } } )->first->id;
    my $product = $service->new_product;
    is $product->id, $last_id + 1, 'right create new product';
};

subtest 'remove_product' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');

    my $result  = $app->schema->resultset('Product')->search( {}, { order_by => { -desc => 'id' } } );
    my $all     = $result->count;
    my $last_id = $result->first->id;
    my $product = $service->remove_product($last_id);
    is $product->id, $last_id, 'right remove product(id)';

    my $after = $app->schema->resultset('Product')->search( {} )->count;
    is $after, $all - 1, 'right remove product(count)';
};

# subtest 'update_product_categories' => sub { };
# subtest 'update_product' => sub { };

done_testing();

__END__
