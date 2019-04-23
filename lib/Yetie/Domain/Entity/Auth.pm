package Yetie::Domain::Entity::Auth;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has _is_verified   => 0;
has action         => q{};
has continue_url   => q{};
has email          => sub { __PACKAGE__->factory('value-email')->construct() };
has error_message  => q{};
has expires        => sub { __PACKAGE__->factory('value-expires')->construct() };
has is_activated   => 0;
has remote_address => 'unknown';
has token          => sub { __PACKAGE__->factory('value-token')->construct() };

sub continue { return shift->{continue_url} // 'RN_home' }

sub is_verified { return shift->_is_verified(@_) }

sub verify_token {
    my ( $self, $last_token ) = @_;

    # Last request token
    return $self->_fails('Different from last token') if !$self->token->equals($last_token);

    # Activated
    return $self->_fails('Activated') if $self->is_activated;

    # Expired
    return $self->_fails('Expired') if $self->expires->is_expired;

    # All passed
    return $self->_is_verified(1);
}

sub _fails {
    my $self = shift;

    $self->_is_verified(0);
    return $self->error_message(shift);
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

=head2 C<continue_url>

=head2 C<email>

=head2 C<error_message>

=head2 C<expires>

=head2 C<is_activated>

=head2 C<remote_address>

=head2 C<token>

=head1 METHODS

L<Yetie::Domain::Entity::Auth> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<continue>

    my $continue_url = $auth->continue;

Return L</continue_url> or 'RN_home'.

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
