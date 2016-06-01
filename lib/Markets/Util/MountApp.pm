package Markets::Util::MountApp;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $arg ) = @_;
    my $prefix = $arg->{prefix};

    $app->routes->any( $prefix )
      ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
}

1;
