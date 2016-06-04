package Markets::MountService;
use Mojo::Base 'Markets';

# This method will run once at server start
sub startup {
    my $self = shift;

    # App mount
    my $r = $self->app->routes;
    # $app->routes->any( $prefix )
    #   ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    $r->any('/admin')
      ->detour( app => Mojolicious::Commands->start_app('Markets::Admin') );
    $r->any('/')
      ->detour( app => Mojolicious::Commands->start_app('Markets::Web') );
}

1;
