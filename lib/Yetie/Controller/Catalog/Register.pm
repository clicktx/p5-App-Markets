package Yetie::Controller::Catalog::Register;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $self = shift;
    $self->render();
}

1;
