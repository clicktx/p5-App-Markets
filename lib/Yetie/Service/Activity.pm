package Yetie::Service::Activity;
use Mojo::Base 'Yetie::Service';

sub add {
    my ( $self, $name, $args ) = @_;

    my $domain_entity = $self->create_domain_entity( $name, $args );
    return $self->resultset('Activity')->add_activity($domain_entity);
}

sub create_domain_entity {
    my ( $self, $name, $args ) = @_;
    my $c = $self->controller;

    my $data = {
        name           => $name,
        action         => $args->{action} // $c->stash('action'),
        remote_address => $c->remote_address // 'unknown',
        user_agent     => $c->req->env->{HTTP_USER_AGENT} // 'unknown',
    };
    $data->{customer_id} = $args->{customer_id} if $args->{customer_id};
    $data->{staff_id}    = $args->{staff_id}    if $args->{staff_id};

    return $c->factory('entity-activity')->construct($data);
}

1;
__END__

=head1 NAME

Yetie::Service::Activity

=head1 SYNOPSIS

=head1 DESCRIPTION

Automatically select the service class from the current route.

=head1 ATTRIBUTES

L<Yetie::Service::Activity> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Activity> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<add>

    $service->add( $activity_name => { \%args } );

=head2 C<create_domain_entity>

    my $entity = $service->create_domain_entity( $activity_name => { \%args } );

Return L<Yetie::Domain::Entity::Activity> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
