package Markets::Core;
use Mojo::Base 'Mojolicious';
use DBI;
use Markets::Util;
use Markets::DB::Schema;
use Markets::Session::Store::Teng;

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

    $self->plugin( Config => { file       => 'config/' . $self->config_file } );
    $self->plugin( Model  => { namespaces => ['Markets::Model'] } );

    # preferences
    my $preferences = $self->model('data-preference')->load;
    $preferences->{LINK_NAME} = 'リンク先';
    $preferences->{ROOT_URL}  = 'http://google.com/';

    foreach my $name ( keys %$preferences ) {
        $self->helper( $name => sub { $preferences->{$name} } );
    }
    $self->helper( LINK_NAME => sub { '上書き' } );    #override ok

    # session
    my $rs = $self->db->resultset('sessions');
    $self->plugin(
        'Markets::Session' => {
            stash_key => 'markets_session',
            store     => Markets::Session::Store::Teng->new( resultset => $rs ),
            expires_delta => 3600,
        }
    );

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # helper
    $self->helper( markets_session => sub { shift->stash('markets_session') } );
}

# dispatcher is Mojolicious::Plugin
sub dispatcher { shift->plugin(@_) }

1;
