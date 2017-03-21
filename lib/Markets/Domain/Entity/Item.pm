package Markets::Domain::Entity::Item;
use Mojo::Base 'Markets::Domain::Entity';
use Mojo::Util qw//;

has [qw/ product_id quantity /];

sub is_equal { shift->hash_code eq shift->hash_code ? 1 : 0 }

sub hash_code {
    my $self = shift;
    Mojo::Util::sha1_sum( $self->product_id );
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
