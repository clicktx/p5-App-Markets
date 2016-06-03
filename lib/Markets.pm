package Markets;
use Mojo::Base 'Mojolicious';
use DBI;
use Markets::Util;
use Markets::DB::Schema;
our $VERSION = '0.01';

has config_file => sub {
    my $mode = shift->app->mode;
    return "${mode}.conf";
};
has util => sub { Markets::Util->new };
has dbh => sub {
    my $self = shift;
    my $conf = $self->app->config->{db} or die "Missing configuration for db";
    my $dsn =
"dbi:$conf->{dbtype}:dbname=$conf->{dbname};host=$conf->{hostname};port=$conf->{port};";
    my $dbh = DBI->connect( $dsn, $conf->{username}, $conf->{password} )
      or die $DBI::errstr;
    say "connecting DB."; 
    say '$app->dbh => ' . $dbh . 'on Markets.pm'; 
    return $dbh;
};
has db => sub {
    my $self = shift;
    Markets::DB::Schema->load(
        dbh       => $self->app->dbh,
        namespace => 'Markets::DB',
    );
};

sub initialize_app {
    my $self = shift;

    # connect to DataBase
    $self->plugin( Config => { file => 'config/' . $self->config_file } );

    # my $db = $self->app->db;

    # config from DataBase
    $self->config( { app_config => 'from_db' } );

    $self->plugin( Model => { namespaces => ['Markets::Model'] } );
    $self->plugin(
        'Markets::Session' => {
            stash_key     => 'session-markets',
            store         => [ dbi => { dbh => $self->app->dbh } ],
            expires_delta => 3600,
        }
    );

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # helper
    $self->helper( mojox_session => sub { shift->stash('session-markets') } );
}

# dispatcher is Mojolicious::Plugin
sub dispatcher { shift->plugin(@_) }

sub startup {
    my $self = shift;
    my $app  = $self->app;

    # App mount
    my $r = $app->routes;
    # $app->routes->any( $prefix )
    #   ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    $r->any('/admin')
      ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    $r->any('/')
      ->detour( app => Mojolicious::Commands->start_app('Markets::Web') );
}

1;
__END__

=head1 NAME

Markets - Markets

=head1 DESCRIPTION

This is a main context class for Markets

=head1 AUTHOR

Markets authors.
