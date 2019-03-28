package Yetie::Controller::Catalog::Email;
use Mojo::Base 'Yetie::Controller::Catalog';

sub sent {
    my $c = shift;

    my $title   = $c->flash('title')   || 'email.sent.title';
    my $message = $c->flash('message') || 'email.sent.message';

    return $c->reply->message( title => $title, message => $message );
}

1;
