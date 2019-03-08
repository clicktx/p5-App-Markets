package Yetie::Schema::ResultSet::AuthorizationRequest;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub disable_token {
    my ( $self, $token ) = @_;
    return $self->search( { token => $token } )->update( { is_activated => 1 } );
}

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

sub store_token {
    my ( $self, $authorization ) = @_;

    my $cb = sub {
        my $email_id = $self->schema->resultset('Email')->find_or_create( { address => $authorization->email } )->id;
        $self->create(
            {
                email_id       => $email_id,
                token          => $authorization->token->value,
                redirect       => $authorization->redirect,
                remote_address => $authorization->remote_address,
                expires        => $authorization->expires->value,
            }
        );
    };
    $self->schema->txn($cb);
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

L<Yetie::Schema::ResultSet::AuthorizationRequest> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::AuthorizationRequest> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<disable_token>

    $resultset->disable_token($token);

Do disabled the Token.

=head2 C<find_last_by_email>

    my $result = $rs->find_last_by_email($email);

Return L<Yetie::Schema::Result::AuthorizationRequest> object or C<undef>.

=head2 C<store_token>

    $rs->store_token($authorization_entity);

Save the token for storage.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
