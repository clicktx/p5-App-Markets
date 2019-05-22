package Yetie::Domain::Value::Email;
use Moose;
extends 'Yetie::Domain::Value';

has _in_storage => ( is => 'ro', default => 0 );
has is_primary  => ( is => 'ro', default => 0 );
has is_verified => ( is => 'ro', default => 0 );

sub in_storage { shift->_in_storage ? 1 : 0 }

sub to_data {
    my $self = shift;

    return {
        _in_storage => $self->_in_storage,
        is_primary  => $self->is_primary,
        is_verified => $self->is_verified,
        value       => $self->value,
    };
}

1;
__END__

=head1 NAME

Yetie::Domain::Value::Email

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Email> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<is_primary>

Return boolean.

=head2 C<is_verified>

Return boolean.

=head1 METHODS

L<Yetie::Domain::Value::Email> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<in_storage>

    my $bool = $value->in_storage;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>, L<Moose>
