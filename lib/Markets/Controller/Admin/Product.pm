package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;
    $self->render();
}

1;
