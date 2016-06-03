package Markets::Admin;
use Mojo::Base 'Markets';

sub startup {
    my $self = shift;
    my $app  = $self->app;
    $self->initialize_app;

    # templets paths
    $app->renderer->paths( ['theme/admin'] );
    say $self->dumper($app->renderer->paths); 

    # Normal route to controller
    my $r = $app->routes;
    $r->get('/')->to('index#welcome');
}

1;
