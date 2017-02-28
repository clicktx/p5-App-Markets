package Markets::Routes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    $self->add_admin_routes($app);
    $self->add_catalog_routes($app);
}

# Routes for Admin
sub add_admin_routes {
    my ( $self, $app ) = @_;
    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )
      ->to( namespace => 'Markets::Controller::Admin' );

    $r->get('/')->to('index#welcome');
    $r->get('/:controller/:action')->to( action => 'index' );
}

# Routes for Catalog
sub add_catalog_routes {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );
    $app->config( history_disable_route_names => [ 'RN_customer_login', 'RN_example' ] );

    # Route Examples
    $r->get('/')->to('example#welcome');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->get('/login_example')->to('login_example#index');
    $r->post('/login_example/attempt')->to('login_example#attempt');

    # Cart
    $r->get('/cart')->to('cart#index')->name('RN_cart');

    # Checkout
    $r->get('/checkout')->to('checkout#index')->name('RN_checkout');

    # For Customer
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
