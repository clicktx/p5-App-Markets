package Yetie::Domain::Entity::Activity;
use Yetie::Domain::Base 'Yetie::Domain::Entity';
use Carp qw(croak);

has [qw(customer_id staff_id)];
has name           => undef;
has action         => undef;
has status         => 'success';
has message        => undef;
has remote_address => 'unkown';
has user_agent     => 'unkown';
has created_at     => undef;

sub type {
    return 'customer' if $_[0]->customer_id;
    return 'staff'    if $_[0]->staff_id;

    croak 'customer_id or staff_id is not set.';
}

sub to_data {
    my $self = shift;
    $self->status;    # dump default attributes

    my $data = $self->SUPER::to_data(@_);
    croak 'Undefined attribute "name"'   unless $data->{name};
    croak 'Undefined attribute "action"' unless $data->{action};
    croak 'Undefined attribute "customer_id" or "staff_id"' if !$data->{customer_id} && !$data->{staff_id};

    # Adapt data structure
    my $type = $self->type;
    my $id   = delete $data->{"$type\_id"};
    $data->{"$type\_activities"} = [ { "$type\_id" => $id } ];

    return $data;
}

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

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
