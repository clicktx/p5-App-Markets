package Markets::Routes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;

    # TODO: 別の場所に移す
    $app->config( history_disable_route_names => [ 'RN_customer_login', 'RN_example' ] );

    $self->add_admin_routes($app);
    $self->add_catalog_routes($app);
}

# Routes for Admin
sub add_admin_routes {
    my ( $self, $app ) = @_;

    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )
      ->to( namespace => 'Markets::Controller::Admin' );

    # [WIP] Not required authorization
    $r->get('/login')->to('staff#login')->name('RN_admin_login');
    $r->post('/login')->to('staff#authen')->name('RN_admin_login_authen');

    # [WIP] Required authorization
    $r = $r->under('/')->to('staff#authorize');
    $r->get( '/' => sub { shift->redirect_to('RN_admin_dashboard') } );
    $r->get('/dashboard')->to('dashboard#index')->name('RN_admin_dashboard');

    # Staff
    $r->get('/logout')->to('staff#logout')->name('RN_admin_logout');

    # Settings
    $r->get('/settings')->to('settings#index')->name('RN_admin_settings');

    # Orders
    $r->get('/orders')->to('orders#index')->name('RN_admin_orders');

    # Products
    $r->get('/products')->to('products#index')->name('RN_admin_products');
}

# Routes for Catalog
sub add_catalog_routes {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );

    # Route Examples
    $r->get('/')->to('example#welcome')->name('RN_top');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->get('/login_example')->to('login_example#index');
    $r->post('/login_example/attempt')->to('login_example#attempt');

    # Cart
    $r->get('/cart')->to('cart#index')->name('RN_cart');

    # Checkout
    $r->get('/checkout')->to('checkout#index')->name('RN_checkout');

    # For Customers
    $r->get('/register')->to('register#index')->name('RN_customer_create_account');
    $r->post('/register')->to('register#index')->name('RN_customer_create_account');

    $r->get('/login')->to('account#login')->name('RN_customer_login');
    $r->post('/login')->to('account#login_authen')->name('RN_customer_login_authen');
    $r->get('/logout')->to('account#logout')->name('RN_customer_logout');
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
