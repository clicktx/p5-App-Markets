package Markets::Web::Dispatcher;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
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

    # Normal route to controller
    $r->get('/')->to('example#welcome');
}

1;
