package Yetie::Domain::List;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has list => sub { Yetie::Domain::Collection->new };

sub each { shift->list->each(@_) }

sub get { shift->list->[ +shift ] }

sub to_data { shift->list->to_data }

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

    $domain->each( sub{ ... } );

    # Longer version
    $domain->list->each( sub{ ... } );

=head2 C<get>

    my $element = $domain->get($int);

Return $element or undef.

=head2 C<to_data>

Dump the data of collection.

    my $data = $domain->to_data;

    # Longer version
    my $data = $domain->list->to_data;

Return Array reference.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Collection>, L<Yetie::Domain::Entity>
