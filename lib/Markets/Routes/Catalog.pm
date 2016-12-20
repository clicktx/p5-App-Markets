package Markets::Routes::Catalog;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->namespaces( ['Markets::Controller::Catalog'] );

    # Routes
    $r->get('/')->to('example#welcome');
    $r->get('/regenerate_sid')->to('example#regenerate_sid');
    $r->post('/signin')->to('example#signin');
    $r->get('/logout')->to('example#logout');
    $r->get('/login')->to('login#index');
    $r->post('/login/attempt')->to('login#attempt');

    # account

    # $r->get('/account/:action')->to();
    # $r->get('/account/login')->to();
    # $r->get('/account/logout')->to();

    # 認証後
    # my $loged_in = $r->under( '/account' =>
    #     sub {
    #         my $c = shift;
    #
    #         # Authenticated
    #         return 1 if $c;
    #
    #         # Not authenticated
    #         $c->render( text => "Don't login." );
    #         return undef;
    #     }
    # );
    my $loged_in = $r->under('/account')->to('account#auth');
    $loged_in->get('/home')->to('example#welcome')->name('account_home');
}

1;
