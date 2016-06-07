package Markets::Admin;
use Mojo::Base 'Markets::Core';

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # templets paths
    my $themes = $self->util->list_themes('theme');
    $self->renderer->paths( ['theme/admin'] );

    # Routes
    $self->dispatcher('Markets::Admin::Dispatcher');
}

1;
