package Markets::Service::Address;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Address') };

sub create_entity {
    my ( $self, $address_id ) = @_;

    my $result = $self->resultset->find($address_id);

    my $data =
      $result
      ? {
        id    => $result->id,
        line1 => $result->line1,
      }
      : {};

    return $self->app->factory('entity-address')->create($data);
}

1;
__END__

=head1 NAME

Markets::Service::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Address> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Address> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $address = $c->service('address')->create_entity($address_id);

Return L<Markets::Domain::Entity::Address> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
