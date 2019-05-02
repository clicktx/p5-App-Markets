package Yetie::Schema::ResultSet::AuthenticationRequest;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_last_by_email {
    my ( $self, $email ) = @_;
    return $self->search(
        {
            'email.address' => $email
        },
        {
            prefetch => 'email',
            order_by => 'me.id DESC'
        }
    )->limit(1)->first;
}

sub remove_request_by_token {
    my ( $self, $token ) = @_;
    return $self->search( { token => $token } )->delete_all;
}

sub store_token {
    my ( $self, $auth ) = @_;

    my $cb = sub {
        my $rs = $self->schema->resultset('Email');
        my $email_id = $rs->find_or_create( { address => $auth->email->value } )->id;
        $self->create(
            {
                email_id       => $email_id,
                token          => $auth->token->value,
                action         => $auth->action,
                continue_url   => $auth->continue_url,
                remote_address => $auth->remote_address,
                expires        => $auth->expires->value,
            }
        );
    };
    return $self->schema->txn($cb);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::AuthenticationRequest

=head1 SYNOPSIS

    my $result = $schema->resultset('AuthenticationRequest')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::AuthenticationRequest> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::AuthenticationRequest> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_last_by_email>

    my $result = $rs->find_last_by_email($email);

Return L<Yetie::Schema::Result::AuthenticationRequest> object or C<undef>.

=head2 C<remove_request_by_token>

    $resultset->remove_request_by_token($token);

Remove token in storage.

=head2 C<store_token>

    $rs->store_token($auth_entity);

Save the token for storage.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
