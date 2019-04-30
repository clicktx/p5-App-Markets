package Yetie::Routes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;

    # TODO: 別の場所に移す
    $app->config( history_disable_route_names => [ 'rn.login', 'rn.example' ] );

    $self->add_admin_routes($app);
    $self->add_catalog_routes($app);
}

# Routes for Admin
sub add_admin_routes {
    my ( $self, $app ) = @_;

    # Default prefix '/admin'
    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )->to( namespace => 'Yetie::Controller' );

    # Not authentication required
    my $login = $r->any('/login')->to( controller => 'admin-staff' );
    $login->any('/')->to('#login')->name('rn.admin.login');

    # Authentication required
    my $if_staff = $r->under(
        sub {
            my $c = shift;
            return 1 if $c->server_session->is_staff_logged_in;

            # NOTE: 最終リクエストがPOSTの場合はhistoryから最後のGETリクエストを取得する？
            #       sessionが切れている（はず）なのでhistoryから取得は難しいか？
            #       cookie_session のlanding_pageで良い？
            #       catalog/staff 両方で必要
            $c->flash( ref => $c->req->url->to_string ) if $c->is_get_request;

            $c->redirect_to( $c->url_for('rn.admin.login') );
            return 0;
        }
    );

    # Dashboard
    $if_staff->get( '/' => sub { shift->redirect_to('rn.admin.dashboard') } );
    $if_staff->get('/dashboard')->to('admin-dashboard#index')->name('rn.admin.dashboard');

    # Logout
    $if_staff->get('/logout')->to('admin-staff#logout')->name('rn.admin.logout');

    # Settings
    my $settings = $if_staff->any('/settings')->to( controller => 'admin-setting' );
    $settings->get('/')->to('#index')->name('rn.admin.settings');
    {
        my $addons = $settings->any('/addon')->to( controller => 'admin-addon' );
        $addons->get('/:action')->to('addon#')->name('rn.admin.settings.addon.actions');
        $addons->get('/')->to('#index')->name('rn.admin.settings.addon');
    }

    # Preferences
    my $pref = $if_staff->any('/preferences')->to( controller => 'admin-preference' );
    $pref->any('/')->to('#index')->name('rn.admin.preferences');

    # Category
    my $category = $if_staff->any('/category')->to( controller => 'admin-category' );
    $category->get('/')->to('#index')->name('rn.admin.category');
    $category->post('/')->to('#index')->name('rn.admin.category.create');
    $category->any('/:category_id/edit')->to('#edit')->name('rn.admin.category.edit');

    # Products
    $if_staff->any('/products')->to('admin-products#index')->name('rn.admin.products');

    # Product
    my $product = $if_staff->any('/product')->to( controller => 'admin-product' )->name('rn.admin.product');
    $product->post('/create')->to('#create')->name('rn.admin.product.create');
    $product->post('/:product_id/delete')->to('#delete')->name('rn.admin.product.delete');
    $product->post('/:product_id/duplicate')->to('#duplicate')->name('rn.admin.product.duplicate');
    $product->any('/:product_id/edit')->to('#edit')->name('rn.admin.product.edit');
    $product->any('/:product_id/edit/category')->to('#category')->name('rn.admin.product.category');

    # Orders
    $if_staff->any('/orders')->to('admin-orders#index')->name('rn.admin.orders');

    # Order
    # NOTE: create, delete, duplicate はPOST requestのみにするべき
    my $order = $if_staff->any('/order')->to( controller => 'admin-order' );
    $order->get('/:id')->to('#details')->name('rn.admin.order.details');
    $order->any('/create')->to('#create')->name('rn.admin.order.create');
    $order->post('/delete')->to('#delete')->name('rn.admin.order.delete');
    $order->any('/:id/edit')->to('#edit')->name('rn.admin.order.edit');
    my $order_edit = $order->any('/:id/edit')->to( controller => 'admin-order-edit' );
    $order_edit->any('/billing_address')->to('#billing_address')->name('rn.admin.order.edit.billing_address');
    $order_edit->any('/shipping_address')->to('#shipping_address')->name('rn.admin.order.edit.shipping_address');
    $order_edit->any('/items')->to('#items')->name('rn.admin.order.edit.items');
    $order->any('/:id/duplicate')->to('#duplicate')->name('rn.admin.order.duplicate');

    # Customers
    $if_staff->any('/customers')->to('admin-customers#index')->name('rn.admin.customers');
}

# Routes for Catalog
sub add_catalog_routes {
    my ( $self, $app ) = @_;
    my $routes = $app->routes->namespaces( ['Yetie::Controller::Catalog'] );

    # remember me
    $routes->get('/auth/remember-me')->to('auth#remember_me')->name('rn.auth.remember_me');

    # Check remember_me token before all routes.
    my $r = $routes->under(
        sub {
            my $c = shift;
            return 1 if $c->is_logged_in;
            return 1 if !$c->is_get_request;
            return 1 if !$c->cookie('has_remember_token');

            $c->continue_url( $c->req->url->to_string );
            $c->redirect_to('rn.auth.remember_me');
            return 0;
        }
    );
    my $if_customer = $r->under(
        sub {
            my $c = shift;
            return 1 if $c->server_session->is_customer_logged_in;

            # NOTE: 最終リクエストがPOSTの場合はhistoryから最後のGETリクエストを取得する？
            #       sessionが切れている（はず）なのでhistoryから取得は難しいか？
            #       cookie_session のlanding_pageで良い？
            #       catalog/staff 両方で必要
            if ( $c->is_get_request ) { $c->continue_url( $c->req->url->to_string ) }
            $c->redirect_to( $c->url_for('rn.login') );
            return 0;
        }
    );

    # Email
    $r->get('/email/sent-magic-link')->to('email#sent_magic_link')->name('rn.email.sent.magic_link');

    # Route Examples
    $r->get('/')->to('example#welcome')->name('rn.home');
    $r->any('/login-example')->to('login_example#index');

    # Cart
    $r->any('/cart')->to('cart#index')->name('rn.cart');
    $r->post('/cart/clear')->to('cart#clear')->name('rn.cart.clear');
    $r->post('/cart/delete')->to('cart#delete')->name('rn.cart.delete');

    # Checkout
    $r->get('/checkout')->to('checkout#index')->name('rn.checkout');
    $r->get('/checkout/complete')->to('checkout#complete')->name('rn.checkout.complete');
    {
        my $checkout = $if_customer->any('/checkout')->to('checkout#');
        $checkout->any('/shipping-address')->to('#shipping_address')->name('rn.checkout.shipping_address');
        $checkout->post('/shipping-address/select')->to('#shipping_address_select')
          ->name('rn.checkout.shipping_address.select');
        $checkout->any('/delivery-options')->to('#delivery_option')->name('rn.checkout.delivery_option');
        $checkout->any('/payment-option')->to('#payment_method')->name('rn.checkout.payment_method');
        $checkout->any('/billing-address')->to('#billing_address')->name('rn.checkout.billing_address');
        $checkout->post('/billing-address/select')->to('#billing_address_select')
          ->name('rn.checkout.billing_address.select');
        $checkout->any('/confirm')->to('#confirm')->name('rn.checkout.confirm');
    }
    my $guest_checkout = $r->any('/checkout/guest')->to('checkout#');
    $guest_checkout->any('/shipping-address')->to('#shipping_address')->name('rn.checkout.guest.shipping_address');

    # For Customers
    {
        # Logout
        $r->get('/logout')->to('auth#logout')->name('rn.customer.logout');

        # Magic link
        $r->get('/magic-link/:token')->to('auth-magic_link#verify')->name('rn.auth.magic_link');
        $r->get('/get-started/:token')->to('auth-magic_link#verify')->name('rn.auth.magic_link.signup');

        # Drop-in
        my $dropin = $r->any('/dropin')->to( controller => 'dropin' );
        $dropin->any('/')->to('#index')->name('rn.dropin');

        # Log-in
        my $login = $r->any('/login')->to( controller => 'login' );
        $login->any('/')->to('#index')->name('rn.login');
        $login->get('/toggle')->to('#toggle')->name('rn.login.toggle');
        $login->any('/with-password')->to('#with_password')->name('rn.login.with_password');

        # Sign-up
        my $signup = $r->any('/signup')->to( controller => 'signup' );
        $signup->any('/')->to('#index')->name('rn.signup');
        $signup->any('/password')->to('#password')->name('rn.signup.password');
        $signup->get('/done')->to('#done')->name('rn.signup.done');

        # Account page
        my $account = $if_customer->any('/account')->to('account#');
        $account->get('/home')->to('#home')->name('rn.account.home');
        $account->get('/orders')->to('#orders')->name('rn.account.orders');
        $account->get('/wishlist')->to('#wishlist')->name('rn.account.wishlist');
    }

    # Product
    $r->any('/product/:product_id')->to('product#index')->name('rn.product');

    # Category
    # $r->get('/:category_name/c/:category_id')->to('category#index')->name('rn.category.name_base');
    $r->get('/category/:category_id')->to('category#index')->name('rn.category');
}

1;
