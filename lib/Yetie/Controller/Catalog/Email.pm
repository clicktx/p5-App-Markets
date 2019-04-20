package Yetie::Controller::Catalog::Email;
use Mojo::Base 'Yetie::Controller::Catalog';

sub sent_magic_link {
    my $c = shift;

    my $title   = 'email.sent.title';
    my $message = 'email.sent.message';
    return $c->reply->message( title => $title, message => $message );
}

1;
