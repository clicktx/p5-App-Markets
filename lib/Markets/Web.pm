package Markets::Web;
use Mojo::Base 'Markets::Core';

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # templets paths
    my $themes = $self->util->list_themes('theme');
    $self->renderer->paths( ['theme/default'] );

    $self->routes->any($self->ADMIN_PREFIX)
      ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );

    # Routes
    $self->dispatcher('Markets::Web::Dispatcher');
}

1;
