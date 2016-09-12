use strict;
use t::Util;

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

    # schema
    my $socket = $mysqld->my_cnf->{socket};
    system "mysqladmin -uroot -S $socket create markets";
    system "mysql -uroot -S $socket markets < share/sql/schema_mysql.sql";
    system "mysql -uroot -S $socket markets < share/sql/default_data_mysql.sql";

    # return dsn
    $mysqld->dsn(
        dbname   => $db_conf->{dbname},
        user     => $db_conf->{user},
        password => $db_conf->{password},
    );
};
print "dsn: $ENV{TEST_MYSQL} \n";
