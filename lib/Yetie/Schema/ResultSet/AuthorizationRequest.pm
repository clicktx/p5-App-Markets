package Yetie::Schema::ResultSet::AuthorizationRequest;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub find_last_by_email {
    my ( $self, $email ) = @_;
    return $self->search( { email => $email }, { order_by => 'id DESC' } )->limit(1)->first;
}

sub store_token {
    my ( $self, $authorization ) = @_;
    return $self->create(
        {
            email      => $authorization->email,
            token      => $authorization->token,
            redirect   => $authorization->redirect,
            request_ip => $authorization->request_ip,
            expires    => $authorization->expires,
        }
    );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::AuthorizationRequest

=head1 SYNOPSIS

    my $result = $schema->resultset('AuthorizationRequest')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::AuthorizationRequest> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::AuthorizationRequest> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_last_by_email>

    my $result = $rs->find_last_by_email($email);

Return L<Yetie::Schema::Result::AuthorizationRequest> object or C<undef>.

=head2 C<store_token>

    $rs->store_token($authorization_entity);

Save the token for storage.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
