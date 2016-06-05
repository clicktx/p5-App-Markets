package Markets;
use Mojo::Base 'Mojolicious';
use DBI;
use Markets::Util;
use Markets::DB::Schema;
our $VERSION = '0.01';

has config_file => sub {
    my $mode = shift->mode;
    return "${mode}.conf";
};
has util => sub { Markets::Util->new };
has dbh => sub {
    my $conf        = shift->config->{db} or die "Missing configuration for db";
    my $data_source = "dbi:$conf->{dbtype}:database=$conf->{dbname}";
    my $dbh         = DBI->connect(
        $data_source, $conf->{username},
        $conf->{password}, { RaiseError => 1 }
    ) or die $DBI::errstr;
    say "connecting DB."; 
    say '$app->dbh => ' . $dbh . 'on Markets.pm'; 
    return $dbh;
};
has db => sub {
    say "+++++ load schema. +++++"; 
    Markets::DB::Schema->load(
        dbh       => shift->dbh,
        namespace => 'Markets::DB',
    );
};

sub initialize_app {
    my $self = shift;

    $self->plugin( Config => { file => 'config/' . $self->config_file } );

    # connect to DataBase
    # my $db = $self->app->db;

    # config from DataBase
    $self->config( { app_config => 'from_db' } );

    $self->plugin( Model => { namespaces => ['Markets::Model'] } );
    $self->plugin(
        'Markets::Session' => {
            stash_key     => 'session-markets',
            store         => [ dbi => { dbh => $self->dbh } ],
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

1;
__END__

=head1 NAME

Markets - Markets

=head1 DESCRIPTION

This is a main context class for Markets

=head1 AUTHOR

Markets authors.
