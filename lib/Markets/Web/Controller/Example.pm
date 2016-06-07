package Markets::Web::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;

    # session
    my $session = $self->mojox_session;
    my $counter = $session->data('counter');
    $counter++;
    $session->data(counter => $counter);
    say "counter: " . $counter;

    # use model
    $self->app->model('logic-base')->do;
    $self->app->model('Data::Base')->do;

    # Render template "example/welcome.html.ep" with message
    $self->render(
        msg => 'Welcome to the Mojolicious real-time web framework!' );
}

1;
