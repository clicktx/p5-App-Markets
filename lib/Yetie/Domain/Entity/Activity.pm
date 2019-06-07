package Yetie::Domain::Entity::Activity;
use Carp qw(croak);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has [qw(customer_id staff_id)] => ( is => 'ro' );
has action         => ( is => 'ro' );
has method         => ( is => 'ro' );
has status         => ( is => 'ro', default => 'success' );
has message        => ( is => 'ro' );
has remote_address => ( is => 'ro', default => 'unkown' );
has user_agent     => ( is => 'ro', default => 'unkown' );
has created_at     => ( is => 'ro' );

sub type {
    return 'customer' if $_[0]->customer_id;
    return 'staff'    if $_[0]->staff_id;

    croak 'customer_id or staff_id is not set.';
}

sub to_data {
    my $self = shift;
    $self->status;    # dump default attributes

    my $data = $self->SUPER::to_data(@_);
    croak 'Undefined attribute "action"' unless $data->{action};
    croak 'Undefined attribute "method"' unless $data->{method};
    croak 'Undefined attribute "customer_id" or "staff_id"' if !$data->{customer_id} && !$data->{staff_id};

    return $data;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Activity

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Activity> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Activity> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<type>

    my $type = $entity->type;

Return string 'customer' or 'staff'.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
