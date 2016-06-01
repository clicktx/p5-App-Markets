package Markets::Admin;
use Mojo::Base 'Markets';
use Data::Dumper;

sub startup {
    my $self = shift;
    my $app  = $self->app;
    $self->initialize_app;

    # templets paths
    $app->renderer->paths( ['theme/admin'] );
    say Dumper $app->renderer->paths; 

    # helper
    $self->helper( mojox_session => sub { shift->stash('session-markets') } );

    # Normal route to controller
    my $r = $app->routes;
    $r = $r->under(
        sub {
            my $self    = shift;
            my $session = $self->mojox_session;
            $session->load;

            if ( $session->sid ) {
                say "ented session expires time."; 
                $session->extend_expires;
            }
            else {
                say "created new session."; 
                $session->create;
            }
            say $session->sid; 
        }
    );

    $r->get('/')->to('index#welcome');
}

1;
