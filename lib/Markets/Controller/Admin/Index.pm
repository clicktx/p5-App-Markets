package Markets::Controller::Admin::Index;
use Mojo::Base 'Markets::Controller::Admin';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;
    say "!!! start action !!!";

    # use model
    $self->app->model('logic-base')->do;
    $self->app->model('Data::Base')->do;

    # Render template "example/welcome.html.ep" with message
    $self->render( msg => 'Admin page.' );
    say "!!! end action !!!";
}

1;
