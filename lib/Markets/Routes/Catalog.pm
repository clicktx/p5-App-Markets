package Markets::Routes::Catalog;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );

    # Routes
    $r->get('/')->to('example#welcome');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->get('/logout')->to('example#logout');
    $r->get('/login')->to('login#index');
    $r->post('/login/attempt')->to('login#attempt');

    # Product
    $r->get('/product/:product_id')->to('product#index')->name('product');
    $r->post('/product/:product_id')->to('product#add_to_cart')->name('add_to_cart');

    # Cart
    $r->get('/cart')->to('cart#index')->name('cart');

    # For Customer
    $r->get('/account/login')->to('account#login')->name('customer_login');
    $r->post('/account/login')->to('account#login_authen')->name('customer_login_authen');
    $r->get('/account/logout')->to('account#logout')->name('customer_logout');

    # 認証後
    {
        my $account = $r->under('/account')->to('account#authorize');
        $account->get('/home')->to('account#home')->name('customer_home');
        $account->get('/wishlist')->to('account#wishlist')->name('wishlist');
    }
}

1;
