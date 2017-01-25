package Markets::Routes::Admin;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->any( $app->pref('admin_uri_prefix') )
      ->to( namespace => 'Markets::Controller::Admin' );

    # Routes for Admin
    $r->get('/')->to('index#welcome');
    $r->get('/:controller/:action')->to( action => 'index' );
}

1;
