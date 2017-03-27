package Markets::Domain::Entity;
use Mojo::Base -base;
use Carp qw/croak/;
use Mojo::Util qw/sha1_sum/;

has id => sub { croak 'Attribute "id" not implemented by subclass' };

sub clone { bless +{ %{ $_[0] } }, ref $_[0] }

sub hash_code { @_ > 1 ? sha1_sum( $_[1] ) : sha1_sum( $_[0]->id ) }

sub is_equal { shift->id eq shift->id ? 1 : 0 }

sub to_hash {
    my $hash = +{ %{ +shift } };
    delete $hash->{id};
    return $hash;
}

1;
__END__

=head1 NAME

Markets::Domain::Entity - Entity Object Base Class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 C<entity_id>

    has entity_id => 'identity';
    has entity_id => sub { shift->more_id };

=head1 METHODS

=head2 C<clone>

    my $clone = $self->clone;

Return object.

=head2 C<hash_code>

    my $sha1_sum = $entity->hash_code;
    my $sha1_sum = $entity->hash_code($bytes);

Return SHA1 checksum. Default bytes is L<Markets::Domain::Entity/id>.

=head2 C<id>

    my $entity_id = $entity->id;

=head2 C<is_equal>

    my $bool = $entity->is_equal($other_entity);

Return boolean value.

=head2 C<to_hash>

    my $data = $entity->to_hash;

Return Hash reference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
