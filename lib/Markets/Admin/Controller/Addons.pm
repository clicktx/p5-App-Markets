package Markets::Admin::Controller::Addons;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

# This action will render a template
sub index {
    my $self = shift;

    # use model
    $self->app->model('logic-base')->do;
    $self->app->model('Data::Base')->do;

    # Render template "example/index.html.ep" with message
    $self->render(
        msg => 'Admin page.' );
}

1;
