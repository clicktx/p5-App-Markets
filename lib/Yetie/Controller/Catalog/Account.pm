package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub home {
    my $c = shift;
    $c->render();
}

sub orders {
    my $c = shift;
    $c->render();
}

sub wishlist {
    my $c = shift;
    $c->render();
}

1;
