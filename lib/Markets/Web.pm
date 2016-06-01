package Markets::Web;
use Mojo::Base 'Markets';
use Data::Dumper;

has config_file => sub {
    my $mode = shift->app->mode;
    return "${mode}.conf";
};

sub initialize_app {
    my $self = shift;

    # connect to DataBase
    $self->plugin( Config => { file => 'config/' . $self->config_file } );
    # my $db = $self->app->db;
    # say Dumper $db; 

    # config from DataBase
    $self->config( { app_config => 'from_db' } );

    $self->plugin( Model => { namespaces => ['Markets::Model'] } );
    $self->plugin(
        session => {
            stash_key     => 'session-markets',
            store         => [ dbi => { dbh => $self->app->dbh } ],
            expires_delta => 3600,
        }
    );
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

    $self->helper( mojox_session => sub { shift->stash('session-markets') } );

    # Routes
    $self->dispatcher('Markets::Web::Dispatcher');

}

1;
