package Yetie::Domain::Entity::Auth;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has token => sub { __PACKAGE__->factory('value-token')->construct() };
has email => sub { __PACKAGE__->factory('value-email')->construct() };
has redirect       => '';
has remote_address => 'unknown';
has is_activated   => 0;
has expires        => sub { __PACKAGE__->factory('value-expires')->construct() };
has error_message  => '';
has _is_verified   => 0;

sub is_verified { shift->_is_verified(@_) }

sub verify_token {
    my ( $self, $last_token ) = @_;

    # Last request token
    return $self->_fails('Different from last token') if !$self->token->equals($last_token);

    # Activated
    return $self->_fails('Activated') if $self->is_activated;

    # Expired
    return $self->_fails('Expired') if $self->expires->is_expired;

    # All passed
    $self->_is_verified(1);
}

sub _fails {
    my $self = shift;

    $self->_is_verified(0);
    $self->error_message(shift);
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Auth

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Auth> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<token>

=head2 C<email>

=head2 C<redirect>

=head2 C<remote_address>

=head2 C<is_activated>

=head2 C<expires>

=head2 C<error_message>

=head1 METHODS

L<Yetie::Domain::Entity::Auth> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<is_verified>

    my $bool = $auth->is_verified;

Return boolean value.

=head2 C<verify_token>

Validate token.
Same as last token, Not activated, and Not expired.

    $auth->verify_token($last_token);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
