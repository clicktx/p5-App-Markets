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

    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )->to( namespace => 'Markets::Controller' );

    # Not required authorization Routes
    {
        my $login = $r->any('login')->to( controller => 'admin-staff' );
        $login->get('/')->to('#login')->name('RN_admin_login');
        $login->post('/')->to('#login_authen')->name('RN_admin_login_authen');
    }

    # Required authorization Routes
    $r = $r->under->to('admin-staff#authorize')->name('RN_admin_bridge');
    {
        # Dashboard
        $r->get( '/' => sub { shift->redirect_to('RN_admin_dashboard') } );
        $r->get('/dashboard')->to('admin-dashboard#index')->name('RN_admin_dashboard');

        # Logout
        $r->get('/logout')->to('admin-staff#logout')->name('RN_admin_logout');

        # Settings
        {
            my $settings = $r->any('/settings')->to( controller => 'admin-setting' );
            $settings->get('/')->to('#index')->name('RN_admin_settings');
            {
                my $addons = $settings->any('/addon')->to( controller => 'admin-addon' );
                $addons->get('/:action')->to('addon#')->name('RN_admin_settings_addon_action');
                $addons->get('/')->to('#index')->name('RN_admin_settings_addon');
            }
        }

        # Preferences
        {
            my $pref = $r->any('/preferences')->to( controller => 'admin-preference' );
            $pref->any('/')->to('#index')->name('RN_admin_preferences');
        }

        # Products
        $r->get('/products')->to('admin-product#index')->name('RN_admin_products');

        # Orders
        {
            my $orders = $r->any('/orders')->to( controller => 'admin-order' );
            $orders->get('/')->to('#index')->name('RN_admin_orders');
            $orders->get('/detail/:id')->to('#detail')->name('RN_admin_orders_detail');
            $orders->get('/edit/:id')->to('#edit')->name('RN_admin_orders_edit');
            $orders->post('/delete')->to('#delete')->name('RN_admin_orders_delete');
        }
    }
}

# Routes for Catalog
sub add_catalog_routes {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );

    # Route Examples
    $r->get('/')->to('example#welcome')->name('RN_top');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->any('/login_example')->to('login_example#index');

    # Cart
    $r->any('/cart')->to('cart#index')->name('RN_cart');
    $r->post('/cart/clear')->to('cart#clear')->name('RN_cart_clear');

    # Checkout
    {
        my $checkout = $r->any('/checkout')->to( controller => 'checkout' );
        $checkout->any('/')->to('#index')->name('RN_checkout');
        $checkout->any('/address')->to('#address')->name('RN_checkout_address');
        $checkout->any('/shipping')->to('#shipping')->name('RN_checkout_shipping');
        $checkout->any('/confirm')->to('#confirm')->name('RN_checkout_confirm');
        $checkout->get('/complete')->to('#complete')->name('RN_checkout_complete');
    }

    # For Customers
    $r->get('/register')->to('register#index')->name('RN_customer_create_account');
    $r->post('/register')->to('register#index')->name('RN_customer_create_account');

    $r->any('/login')->to('account#login')->name('RN_customer_login');
    $r->get('/logout')->to('account#logout')->name('RN_customer_logout');
    {
        # Required authorization Routes
        my $account = $r->under('/account')->to('account#authorize')->name('RN_customer_bridge');
        $account->get('/home')->to('account#home')->name('RN_customer_home');
        $account->get('/orders')->to('account#orders')->name('RN_customer_orders');
        $account->get('/wishlist')->to('account#wishlist')->name('RN_customer_wishlist');
    }

    # Product
    $r->any('/product/:product_id')->to('product#index')->name('RN_product');

    # Category
    $r->get('/category/:category_id')->to('category#index')->name('RN_category');
    $r->get('/:category_name')->to('category#index')->name('RN_category_name_base');
}

1;
