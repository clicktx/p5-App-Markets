package Yetie::Controller::Admin::Dashboard;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;
    $self->render();
}

1;
