package Yetie::Controller::Catalog::Email;
use Mojo::Base 'Yetie::Controller::Catalog';

sub sent_magic_link {
    my $c = shift;
    return $c->render();
}

1;
