use Mojo::Base -strict;

use File::Spec;
use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', '..', 'lib' ), File::Spec->catdir( dirname(__FILE__), '..', '..' );
use t::Util;
use Yetie::Schema;
use Yetie::Install::Util;
use Mojo::File qw/path/;

$ENV{TEST_MYSQL} ||= do {
    require Test::mysqld;
    my $conf = Yetie::Install::Util::load_config();

    say 'Starting mysqld...';
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
    say 'Create db...';
    system 'mysqladmin -uroot -S ' . $conf->{db}->{socket} . ' create t_yetie_db';

    # create table
    say 'Create tables...';
    my $schema = Yetie::Schema->connect( $dsn, $conf->{user}, $conf->{password} );
    $schema->deploy;

    # insert data
    say 'Insert data...';
    my @paths;
    my $base_dir = dirname(__FILE__);
    push @paths,
      (
        path( $base_dir, '..', '..',  'share', 'default_data.pl' ),
        path( $base_dir, '..', 'App', 'share', 'sample_data.pl' )
      );
    Yetie::Install::Util::insert_data( $schema, $_ ) for @paths;

    $dsn;
};
print "dsn: $ENV{TEST_MYSQL} \n";
