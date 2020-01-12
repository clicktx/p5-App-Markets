package Yetie::Domain::Set;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has hash_set => (
    is      => 'rw',
    isa     => 'Yetie::Domain::IxHash',
    default => sub { Yetie::Domain::IxHash->new },
);

sub each { return shift->hash_set->each(@_) }

sub get { return shift->hash_set->{ +shift } }

sub has_elements { return shift->hash_set->size ? 1 : 0 }

sub to_data { return shift->hash_set->to_data }

sub to_order_data { return shift->hash_set->to_order_data }

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Set

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Set> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<hash_set>

Return C<Yetie::Domain::IxHash> object.

=head1 METHODS

L<Yetie::Domain::Set> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<each>

    $set->each( sub{ ... } );

    # Longer version
    $set->hash_set->each( sub{ ... } );

=head2 C<get>

    my $element = $set->get($key);

Return $element or undef.

=head2 C<has_elements>

    my $bool = $set->has_elements;

Return true if hash_set attribute has elements.

=head2 C<to_data>

Dump the data of hash set.

    my $data = $set->to_data;

    # Longer version
    my $data = $set->hash_set->to_data;

Return Hash reference.

=head2 C<to_order_data>

L</to_data> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::IxHash>, L<Yetie::Domain::Entity>
