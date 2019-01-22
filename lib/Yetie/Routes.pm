package Yetie::Routes;
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
    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )->to( namespace => 'Yetie::Controller' );

    # Not authorization required
    my $login = $r->any('login')->to( controller => 'admin-staff' );
    $login->any('/')->to('#login')->name('RN_admin_login');

    # Authorization required
    $r = $r->under->to('admin-staff#authorize')->name('RN_admin_bridge');

    # Dashboard
    $r->get( '/' => sub { shift->redirect_to('RN_admin_dashboard') } );
    $r->get('/dashboard')->to('admin-dashboard#index')->name('RN_admin_dashboard');

    # Logout
    $r->get('/logout')->to('admin-staff#logout')->name('RN_admin_logout');

    # Settings
    my $settings = $r->any('/settings')->to( controller => 'admin-setting' );
    $settings->get('/')->to('#index')->name('RN_admin_settings');
    {
        my $addons = $settings->any('/addon')->to( controller => 'admin-addon' );
        $addons->get('/:action')->to('addon#')->name('RN_admin_settings_addon_action');
        $addons->get('/')->to('#index')->name('RN_admin_settings_addon');
    }

    # Preferences
    my $pref = $r->any('/preferences')->to( controller => 'admin-preference' );
    $pref->any('/')->to('#index')->name('RN_admin_preferences');

    # Category
    my $category = $r->any('/category')->to( controller => 'admin-category' );
    $category->get('/')->to('#index')->name('RN_admin_category');
    $category->post('/')->to('#index')->name('RN_admin_category_create');
    $category->any('/:category_id/edit')->to('#edit')->name('RN_admin_category_edit');

    # Products
    $r->any('/products')->to('admin-products#index')->name('RN_admin_products');

    # Product
    my $product = $r->any('/product')->to( controller => 'admin-product' )->name('RN_admin_product');
    $product->post('/create')->to('#create')->name('RN_admin_product_create');
    $product->post('/:product_id/delete')->to('#delete')->name('RN_admin_product_delete');
    $product->post('/:product_id/duplicate')->to('#duplicate')->name('RN_admin_product_duplicate');
    $product->any('/:product_id/edit')->to('#edit')->name('RN_admin_product_edit');
    $product->any('/:product_id/edit/category')->to('#category')->name('RN_admin_product_category');

    # Orders
    $r->any('/orders')->to('admin-orders#index')->name('RN_admin_orders');

    # Order
    # NOTE: create, delete, duplicate はPOST requestのみにするべき
    my $order = $r->any('/order')->to( controller => 'admin-order' );
    $order->get('/:id')->to('#details')->name('RN_admin_order_details');
    $order->any('/create')->to('#create')->name('RN_admin_order_create');
    $order->post('/delete')->to('#delete')->name('RN_admin_order_delete');
    $order->any('/:id/edit')->to('#edit')->name('RN_admin_order_edit');
    my $order_edit = $order->any('/:id/edit')->to( controller => 'admin-order-edit' );
    $order_edit->any('/billing_address')->to('#billing_address')->name('RN_admin_order_edit_billing_address');
    $order_edit->any('/shipping_address')->to('#shipping_address')->name('RN_admin_order_edit_shipping_address');
    $order_edit->any('/items')->to('#items')->name('RN_admin_order_edit_items');

    # $order->any('/create')->to('#create')->name('RN_admin_order_create');
    $order->any('/:id/duplicate')->to('#duplicate')->name('RN_admin_order_duplicate');

    # Customers
    $r->any('/customers')->to('admin-customers#index')->name('RN_admin_customers');
}

# Routes for Catalog
sub add_catalog_routes {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Yetie::Controller::Catalog'] );

    # Route Examples
    $r->get('/')->to('example#welcome')->name('RN_home');
    $r->any('/login-example')->to('login_example#index');

    # Cart
    $r->any('/cart')->to('cart#index')->name('RN_cart');
    $r->post('/cart/clear')->to('cart#clear')->name('RN_cart_clear');
    $r->post('/cart/delete')->to('cart#delete')->name('RN_cart_delete');

    # Checkout
    $r->any('/checkout')->to('checkout#index')->name('RN_checkout');
    $r->get('/checkout/complete')->to('checkout#complete')->name('RN_checkout_complete');
    {
        my $authorize = $r->under('/checkout')->to('account#authorize')->name('RN_checkout_bridge');
        my $checkout  = $authorize->any('/')->to('checkout#');
        $checkout->any('/shipping-address')->to('#shipping_address')->name('RN_checkout_shipping_address');
        $checkout->post('/shipping-address/select')->to('#shipping_address_select')
          ->name('RN_checkout_shipping_address_select');
        $checkout->any('/delivery-options')->to('#delivery_option')->name('RN_checkout_delivery_option');
        $checkout->any('/payment-option')->to('#payment_method')->name('RN_checkout_payment_method');
        $checkout->any('/billing-address')->to('#billing_address')->name('RN_checkout_billing_address');
        $checkout->post('/billing-address/select')->to('#billing_address_select')
          ->name('RN_checkout_billing_address_select');
        $checkout->any('/confirm')->to('#confirm')->name('RN_checkout_confirm');
    }
    my $guest_checkout = $r->any('/checkout/guest')->to('checkout#');
    $guest_checkout->any('/shipping-address')->to('#shipping_address')->name('RN_guest_checkout_shipping_address');

    # For Customers
    $r->get('/logout')->to('account#logout')->name('RN_customer_logout');

    {
        # Log-in
        my $login = $r->any('/login')->to( controller => 'login' );
        $login->get('/')->to('#index')->name('RN_customer_login');
        $login->get('/email-sended')->to('#email_sended')->name('RN_customer_login_email_sended');
        $login->get('/toggle')->to('#toggle')->name('RN_customer_login_toggle');
        $login->get('/token/:token')->to('#callback')->name('RN_callback_customer_login');
        $login->any('/magic-link')->to('#magic_link')->name('RN_customer_login_magic_link');
        $login->any('/with-password')->to('#with_password')->name('RN_customer_login_with_password');
    }
    {
        # Sign-up
        my $signup = $r->any('/signup')->to( controller => 'signup' );
        $signup->any('/')->to('#index')->name('RN_customer_signup');
        $signup->get('/email-sended')->to('#email_sended')->name('RN_customer_signup_email_sended');
        $signup->get('/done')->to('#done')->name('RN_customer_signup_done');
        $signup->get('/get-started/:token')->to('#callback')->name('RN_callback_customer_signup');
    }
    {
        # Authorization required
        my $account = $r->under('/account')->to('account#authorize')->name('RN_customer_bridge');
        $account->get('/home')->to('account#home')->name('RN_customer_home');
        $account->get('/orders')->to('account#orders')->name('RN_customer_orders');
        $account->get('/wishlist')->to('account#wishlist')->name('RN_customer_wishlist');
    }

    # Product
    $r->any('/product/:product_id')->to('product#index')->name('RN_product');

    # Category
    # $r->get('/:category_name/c/:category_id')->to('category#index')->name('RN_category_name_base');
    $r->get('/category/:category_id')->to('category#index')->name('RN_category');
}

1;
