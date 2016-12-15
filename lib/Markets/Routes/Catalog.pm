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
}

1;
