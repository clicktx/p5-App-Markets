use strict;
use warnings;
use t::Util;

use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', '..', 'lib' );
use Markets::Schema;

$ENV{TEST_MYSQL} ||= do {
    require Test::mysqld;
    print "Starting mysqld...\n";
    my $conf    = t::Util->load_config;
    my $db_conf = $conf->{db};

    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip-networking'        => '',
            'default-storage-engine' => 'innodb',
            'socket'                 => '/tmp/mysql.sock',
        }
    ) or die $Test::mysqld::errstr;
    $HARRIET_GUARDS::MYSQLD = $mysqld;

    # dsn
    my $dsn = $mysqld->dsn(
        dbname   => $db_conf->{dbname},
        user     => $db_conf->{user},
        password => $db_conf->{password},
    );

    # create db
    my $socket = $mysqld->my_cnf->{socket};
    system "mysqladmin -uroot -S $socket create markets";

    # create table
    my $schema = Markets::Schema->connect($dsn);
    $schema->deploy;

    # insert data
    # system "mysql -uroot -S $socket markets < share/sql/insert_default_data.sql";
    # system "mysql -uroot -S $socket markets < t/App/share/sql/insert_test_data.sql";
    my @paths;
    push @paths, File::Spec->catdir( dirname(__FILE__), '..', '..',  'share', 'default_data.pl' );
    push @paths, File::Spec->catdir( dirname(__FILE__), '..', 'App', 'share', 'test_data.pl' );
    _insert_data( $schema, $_ ) for @paths;

    $dsn;
};
print "dsn: $ENV{TEST_MYSQL} \n";

# insert dafault data to DB
use Mojo::File 'path';
use Mojo::Util 'decode';

sub _insert_data {
    my $schema = shift;
    my $path   = shift;

    my $content = decode( 'UTF-8', path($path)->slurp );
    my $data = eval "$content";

    my @keys = keys %{$data};
    foreach my $schema_name (@keys) {
        my $action;
        $action = 'create'   if ref $data->{$schema_name} eq 'HASH';
        $action = 'populate' if ref $data->{$schema_name} eq 'ARRAY';
        $schema->resultset($schema_name)->$action( $data->{$schema_name} );
    }
}
