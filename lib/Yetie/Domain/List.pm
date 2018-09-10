package Yetie::Domain::List;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has list => sub { Yetie::Domain::Collection->new };

sub each { shift->list->each(@_) }

1;
__END__

=head1 NAME

Yetie::Domain::List

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<list>

Return C<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::List> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<each>

    $items->each( sub{ ... } );

alias method $items->list->each()

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Collection>, L<Yetie::Domain::Entity>
