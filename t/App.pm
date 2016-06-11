package t::App;
use Mojo::Base 'Markets::Web';

has dbh => sub {
    my $conf = shift->config->{db} or die "Missing configuration for db";
    my $dbh = DBI->connect( $ENV{TEST_MYSQL} ) or die $DBI::errstr;
    return $dbh;
};

1;
