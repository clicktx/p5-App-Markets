package Yetie::Controller::Admin::Dashboard;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;
    $c->render();
}

1;
