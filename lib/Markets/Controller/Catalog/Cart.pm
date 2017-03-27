package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    $self->render();
}

1;
