package Markets::Domain::Entity::Item;
use Markets::Domain::Entity;

has id => sub {
    my $self  = shift;
    my $bytes = $self->product_id;
    $self->hash_code($bytes);
};
has product_id => '';
has quantity   => 0;

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
