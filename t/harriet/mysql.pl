use strict;
use warnings;

use File::Spec;
use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', '..', 'lib' ), File::Spec->catdir( dirname(__FILE__), '..', '..' );
use t::Util;
use Markets::Schema;
use Markets::Install::Util;
use Mojo::File qw/path/;

$ENV{TEST_MYSQL} ||= do {
    require Test::mysqld;
    print "Starting mysqld...\n";

    my $conf   = Markets::Install::Util::load_config();
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip-networking'        => '',
            'default-storage-engine' => 'innodb',
            'socket'                 => $conf->{db}->{socket},
        }
    ) or die $Test::mysqld::errstr;
    $HARRIET_GUARDS::MYSQLD = $mysqld;

    # dsn
    my $dsn = $mysqld->dsn( %{ $conf->{db} } );

    # create db
    system 'mysqladmin -uroot -S ' . $conf->{db}->{socket} . ' create t_markets_db';

    # create table
    my $schema = Markets::Schema->connect($dsn);
    $schema->deploy;

    # insert data
    my @paths;
    my $base_dir = dirname(__FILE__);
    push @paths,
      (
        path( $base_dir, '..', '..',  'share', 'default_data.pl' ),
        path( $base_dir, '..', 'App', 'share', 'test_data.pl' )
      );
    Markets::Install::Util::insert_data( $schema, $_ ) for @paths;

    $dsn;
};
print "dsn: $ENV{TEST_MYSQL} \n";
