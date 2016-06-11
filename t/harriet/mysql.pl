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
    $mysqld->dsn;
};
print "dsn: $ENV{TEST_MYSQL} \n";
