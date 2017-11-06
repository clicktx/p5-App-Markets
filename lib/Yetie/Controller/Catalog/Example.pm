package Yetie::Controller::Catalog::Example;
use Mojo::Base 'Yetie::Controller::Catalog';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;
    say "!!! start action !!!";

    # emit hook
    $self->app->plugins->emit_hook( before_welcome => $self );

    # session
    my $session = $self->server_session;
    my $counter = $session->data('counter');
    $counter++;
    $session->data( counter => $counter );

    say "counter: " . $counter;      # debug

    # Render template "example/welcome.html.ep" with message
    $self->render( msg => 'Welcome to the Mojolicious real-time web framework!' );

    say "!!! end action !!!";
}

sub regenerate_sid {
    my $self = shift;
    say "regenerate_sid";

    my $session = $self->server_session;
    my $sid     = $session->regenerate_sid;
    say "  .. regenerate_sid: " . $sid;
    $self->render(
        msg      => 'update sid!',
        template => 'example/welcome'
    );
}

sub signin {
    my $self = shift;

    $self->render(
        msg      => 'signin!',
        template => 'example/welcome'
    );
}

1;