package Markets::Web::Dispatcher;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes;

    # Normal route to controller
    $r->get('/')->to('example#welcome');
}

1;
