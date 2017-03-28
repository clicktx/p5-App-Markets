package Markets::Controller::Catalog::Register;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    $self->render();
}

1;
