package Yetie::Domain::Entity::Auth;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has _is_verified => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

has action => (
    is      => 'ro',
    isa     => 'Str',
    default => q{}
);

has continue_url => (
    is      => 'ro',
    isa     => 'Str | Undef',
    default => q{}
);

has email => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Email',
    default => sub { __PACKAGE__->factory('value-email')->construct() }
);

has error_message => (
    is      => 'rw',
    isa     => 'Str',
    default => q{}
);

has expires => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Expires',
    default => sub { __PACKAGE__->factory('value-expires')->construct() }
);

has is_activated => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

has remote_address => (
    is      => 'ro',
    isa     => 'Str',
    default => 'unknown'
);

has token => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Token',
    default => sub { __PACKAGE__->factory('value-token')->construct() }
);

sub continue { return shift->continue_url || 'rn.home' }

sub is_verified { return shift->_is_verified(@_) }

sub verify_token {
    my ( $self, $last_token ) = @_;

    # Last request token
    return $self->_fails('Different from last token') if $self->token->value ne $last_token;

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

no Moose;
__PACKAGE__->meta->make_immutable;

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

Return L</continue_url> or 'rn.home'.

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
