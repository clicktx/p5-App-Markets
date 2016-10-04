package Markets::Web::DispatchRoutes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->any()->to( namespace => 'Markets::Web::Controller' );

    # Normal route to controller
    $r->get('/')->to('example#welcome');
    $r->get('/login')->to('login#index');
    $r->post('/login/attempt')->to('login#attempt');
}

1;
