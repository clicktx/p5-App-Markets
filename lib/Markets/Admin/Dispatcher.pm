package Markets::Admin::Dispatcher;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes;

    # Normal route to controller
    $r->get('/')->to('index#welcome');
}

1;
