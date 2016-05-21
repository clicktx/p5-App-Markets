package Markets::Web;
use Mojo::Base 'Markets';
use Data::Dumper;

has config_file => sub {
    my $self = shift;
    my $env = $ENV{MOJO_MODE} // 'develop';
    return "${env}.conf";
};

sub initialize_app {
    my $self = shift;

    # connect to DataBase
    $self->plugin( Config => { file => 'etc/' . $self->config_file } );

    $self->plugin( Model => { namespaces => ['Markets::Model'] } );

    # config from DataBase
    $self->config( { app_config => 'from_db' } );
}

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
