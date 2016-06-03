package Markets::Web;
use Mojo::Base 'Markets';

# This method will run once at server start
sub startup {
    my $self = shift;
    my $app  = $self->app;
    $self->initialize_app;

    # templets paths
    my $themes = $app->util->list_themes('theme');
    say $self->dumper($themes); 
    $app->renderer->paths( ['theme/default'] );

    # Routes
    $self->dispatcher('Markets::Web::Dispatcher');
}

1;
