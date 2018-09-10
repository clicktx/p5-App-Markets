package Yetie::Domain::Set;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has hash_set => sub { Yetie::Domain::IxHash->new };

sub each { shift->hash_set->each(@_) }

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

    $items->each( sub{ ... } );

alias method $items->hash_set->each()

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::IxHash>, L<Yetie::Domain::Entity>
