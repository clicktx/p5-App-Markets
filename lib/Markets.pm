package Markets;
use Mojo::Base 'Mojolicious';
our $VERSION = '0.01';

# This method will run once at server start
sub startup {

    # my $self = shift;

    # App mount
    # my $r = $self->app->routes;
    # $app->routes->any( $prefix )
    #   ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    # $r->any('/admin')
    #   ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    # $r->any('/')
    #   ->detour( app => Mojolicious::Commands->start_app('Markets::Web') );
}

1;
__END__

=head1 NAME

Markets - Markets

=head1 DESCRIPTION

This is a main context class for Markets

=head1 AUTHOR

Markets authors.
