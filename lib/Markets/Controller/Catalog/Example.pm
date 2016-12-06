package Markets::Controller::Catalog::Example;
use Mojo::Base 'Markets::Controller';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;
    say "!!! start action !!!";

    # emit hook
    $self->app->plugins->emit_hook( before_welcome => $self );

    # session
    my $session = $self->markets_session;
    my $counter = $session->data('counter');
    $counter++;
    $session->data( counter => $counter );
    say "counter: " . $counter;      # debug
    say $self->const('ROOT_URL');    # debug

    # use model
    $self->app->model('logic-base')->do;
    $self->app->model('Data::Base')->do;

    # Render template "example/welcome.html.ep" with message
    $self->render( msg => 'Welcome to the Mojolicious real-time web framework!' );

    say "!!! end action !!!";
}

sub regenerate_session {
    my $self = shift;
    say "regenerate_session";

    my $session = $self->markets_session;
    $session->regenerate_session;
    $self->stash( template => 'example/welcome' );
    $self->welcome;
}

1;
