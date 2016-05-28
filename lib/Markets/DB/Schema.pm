package Markets::DB::Schema;
use Mojo::Base -base;
use Teng::Schema::Loader;

sub load {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    Teng::Schema::Loader->load(
        dbh       => $args{dbh},
        namespace => $args{namespace},
    );
}

1;
