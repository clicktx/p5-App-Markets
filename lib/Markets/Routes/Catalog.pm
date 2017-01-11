package Markets::Routes::Catalog;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );

    # Routes
    # TODO: routeの名前にはプリフィックス RN_ (Route Name)を付ける
    $r->get('/')->to('example#welcome');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->get('/logout')->to('example#logout');
    $r->get('/login')->to('login#index');
    $r->post('/login/attempt')->to('login#attempt');

    # Cart
    $r->get('/cart')->to('cart#index')->name('RN_cart');

    # Checkout
    $r->get('/checkout')->to('checkout#index')->name('RN_checkout');

    # For Customer
    $r->get('/register')->to('register#index')->name('RN_customer_create_account');
    $r->post('/register')->to('register#index')->name('RN_customer_create_account');

    $r->get('/account/login')->to('account#login')->name('RN_customer_login');
    $r->post('/account/login')->to('account#login_authen')->name('RN_customer_login_authen');
    $r->get('/account/logout')->to('account#logout')->name('RN_customer_logout');
    {
        # Required authorization
        my $account = $r->under('/account')->to('account#authorize');
        $account->get('/home')->to('account#home')->name('RN_customer_home');
        $account->get('/orders')->to('account#orders')->name('RN_customer_orders');
        $account->get('/wishlist')->to('account#wishlist')->name('RN_customer_wishlist');
    }

    # Product
    $r->get('/product/:product_id')->to('product#index')->name('RN_product');
    $r->post('/product/:product_id')->to('product#add_to_cart')->name('RN_add_to_cart');

    # Category
    $r->get('/category/:category_id')->to('category#index')->name('RN_category');
    $r->get('/:category_name')->to('category#index')->name('RN_category_name_base');
}

1;
