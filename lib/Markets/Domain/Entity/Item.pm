package Markets::Domain::Entity::Item;
use Mojo::Base 'Markets::Domain::Entity';

has [qw/ product_id quantity /];

sub to_hash {
    my $self = shift;
    my $item = {
        product_id => $self->product_id,
        quantity   => $self->quantity,
    };

    return $item;
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Item

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Item> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
