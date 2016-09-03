package Markets::Web::DispatchRoutes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->any()->to( namespace => 'Markets::Web::Controller' );

    # Normal route to controller
    $r->get('/')->to('example#welcome');
}

1;
