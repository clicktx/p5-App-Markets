package Markets;
use Mojo::Base 'Mojolicious';
use DBI;
use Markets::Util;
use Markets::DB::Schema;
our $VERSION = '0.01';

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
        dbh => $self->app->dbh,
        namespace => 'Markets::DB',
    );
};

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
