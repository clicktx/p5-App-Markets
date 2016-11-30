package Markets::Web::Admin::Routes;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    my $r = $app->routes->any( $app->const('ADMIN_PAGE_PREFIX') )
      ->to( namespace => 'Markets::Web::Admin::Controller' );

    # Emit before_action hook
    $r = $r->under( sub { $_[0]->app->plugins->emit_hook( before_action => $_[0] ) } );

    # CSRF protection
    $r = $r->under(
        sub {
            my $c = shift;

            return 1 if $c->req->method eq 'GET';
            return 1 unless $c->validation->csrf_protect->has_error('csrf_token');
            $c->render(
                text   => 'Bad CSRF token!',
                status => 403,
            );
            return 0;
        }
    );

    # Routes for Admin
    $r->get('/')->to('index#welcome');
    $r->get('/:controller/:action')->to( action => 'index' );
}

1;
