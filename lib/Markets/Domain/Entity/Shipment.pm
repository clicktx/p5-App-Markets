package Markets::Domain::Entity::Shipment;
use Mojo::Base 'Markets::Domain::Entity';

has [qw/ address items /];

has id => sub { shift->hash_code };

sub hash_code {
    my $self  = shift;
    my $bytes = $self->address;
    $self->SUPER::hash_code($bytes);
}

sub item_count {
    my $cnt = 0;
    shift->items->each( sub { $cnt += shift->quantity } );
    return $cnt;
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Shipment> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
