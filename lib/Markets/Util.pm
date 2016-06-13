package Markets::Util;
use Mojo::Base -base;
use File::Find::Rule;

sub list_themes {
    my ( $self, $dir ) = ( shift, shift // '' );
    my $rule = File::Find::Rule->new->name(qw/default admin/);
    my @subdirs =
      File::Find::Rule->directory->maxdepth(1)->not($rule)->in($dir);
    shift @subdirs;
    return \@subdirs;
}

sub initialize_dsn {
    my ( $self, $conf ) = @_;
    my $dsn;
    if ( $ENV{TEST_MYSQL} ) {
        $dsn = $ENV{TEST_MYSQL};
    }
    else {
        $dsn =
            "DBI:$conf->{dbtype}:dbname=$conf->{dbname};"
          . "host=$conf->{host};port=$conf->{port};"
          . "user=$conf->{user};password=$conf->{password};";
    }
    return $dsn;
}

1;
