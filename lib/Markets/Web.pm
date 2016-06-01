package Markets::Web;
use Mojo::Base 'Markets';
use Data::Dumper;

# This method will run once at server start
sub startup {
    my $self = shift;
    my $app  = $self->app;
    $self->initialize_app;

    # templets paths
    my $themes = $app->util->list_themes('theme');
    say Dumper $themes; 
    $app->renderer->paths( ['theme/default'] );

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Routes
    $self->dispatcher('Markets::Web::Dispatcher');

}

1;
