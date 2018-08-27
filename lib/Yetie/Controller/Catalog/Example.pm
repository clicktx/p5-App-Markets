package Yetie::Controller::Catalog::Example;
use Mojo::Base 'Yetie::Controller::Catalog';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $c = shift;
    say "!!! start action !!!";

    # emit hook
    $c->app->plugins->emit_hook( before_welcome => $c );

    # session
    my $session = $c->server_session;
    my $counter = $session->data('counter');
    $counter++;
    $session->data( counter => $counter );

    say "counter: " . $counter;      # debug

    # Render template "example/welcome.html.ep" with message
    $c->render( msg => 'Welcome to the Mojolicious real-time web framework!' );

    say "!!! end action !!!";
}

sub regenerate_sid {
    my $c = shift;
    say "regenerate_sid";

    my $session = $c->server_session;
    my $sid     = $session->regenerate_sid;
    say "  .. regenerate_sid: " . $sid;
    $c->render(
        msg      => 'update sid!',
        template => 'example/welcome'
    );
}

sub signin {
    my $c = shift;

    $c->render(
        msg      => 'signin!',
        template => 'example/welcome'
    );
}

1;
