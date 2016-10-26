package Markets::Web::Catalog::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;

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
    $self->render(
        msg => 'Welcome to the Mojolicious real-time web framework!' );
}

1;
