package Yetie::Service::Email;
use Mojo::Base 'Yetie::Service';

sub find_email {
    my ( $self, $email_addr ) = @_;

    my $result = $self->resultset('Email')->find( { address => $email_addr } );
    my $data = $result ? $result->to_data : { value => $email_addr };
    return $self->factory('value-email')->construct($data);
}

sub send_magic_link {
    my ( $self, $email_addr, $callback_route ) = @_;
    my $c = $self->controller;

    # WIP: 送信制限、エラー等
    # return $c->reply->error();

    my $token = $c->service('authentication')->generate_token( $email_addr, { redirect => $callback_route } );
    my $url = $c->url_for( 'rn.auth.magic_link.verify', token => $token->value );

    # WIP: Send email
    say $url->to_abs;

    return $c->reply->message();
}

1;
__END__

=head1 NAME

Yetie::Service::Email

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Email> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Email> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<find_email>

    my $domain_value = $service->find_email('foo@bar.baz');

Return L<Yetie::Domain::Value::Email> object.

=head2 C<send_magic_link>

    $service->send_magic_link( 'foo@bar.baz', 'RN_home' );

Return C<reply-E<gt>error> or C<reply-E<gt>message>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
