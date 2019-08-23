use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
use_ok 'Yetie::Service::Product';

subtest 'duplicate_product' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');

    my $last_id = $app->schema->resultset('Product')->last_id;
    my $orig    = $app->schema->resultset('Product')->find(1);

    my $product = $service->duplicate_product(1);
    is $product->id, $last_id + 1, 'right id';
    is $product->description, $orig->description, 'right description';
    is $product->price->{value}, $orig->price, 'right price';
    like $product->title, qr/copy/, 'copy title';
    is $product->product_categories, $orig->product_categories, 'right product_categories';
};

subtest 'find_product' => sub {
    my $e = $app->service('product')->find_product(1);
    isa_ok $e, 'Yetie::Domain::Entity::Product';
    is $e->id, 1, 'right ID';

    $e = $app->service('product')->find_product(999);
    is $e->id, undef, 'right not found product';
};

subtest 'new_product' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('product');

    my $last_id = $app->schema->resultset('Product')->last_id;
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

done_testing();

__END__
