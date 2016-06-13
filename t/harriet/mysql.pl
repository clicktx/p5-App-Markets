use strict;
$ENV{TEST_MYSQL} ||= do {
    require Test::mysqld;
    print "Starting mysqld...\n";
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip-networking'        => '',
            'default-storage-engine' => 'innodb',
        }
    ) or die $Test::mysqld::errstr;
    $HARRIET_GUARDS::MYSQLD = $mysqld;

    # schema
    my $socket = $mysqld->my_cnf->{socket};
    system "mysqladmin -uroot -S $socket create markets";
    system "mysql -uroot -S $socket markets < share/sql/schema_mysql.sql";
    system "mysql -uroot -S $socket markets < share/sql/data_mysql.sql";

    # return dsn
    $mysqld->dsn(dbname => 'markets');
};
print "dsn: $ENV{TEST_MYSQL} \n";
