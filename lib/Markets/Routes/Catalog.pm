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

    # For Customer
    $r->get('/account/login')->to('account#login')->name('customer_login');
    $r->post('/account/login')->to('account#login_authen')->name('customer_login_authen');

    # 認証後
    my $account = $r->under('/account')->to('account#authorize');
    $account->get('/home')->to('account#home')->name('customer_home');
    $account->get('/logout')->to('account#logout')->name('customer_logout');

}

1;
