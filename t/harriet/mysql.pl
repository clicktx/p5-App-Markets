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
    system "mysql -uroot -S $socket markets < share/sql/insert_default_data.sql";
    system "mysql -uroot -S $socket markets < t/App/share/sql/insert_test_data.sql";

    $dsn;
};
print "dsn: $ENV{TEST_MYSQL} \n";
