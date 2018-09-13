package Yetie::Domain::List;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has list => sub { Yetie::Domain::Collection->new };

sub each { shift->list->each(@_) }

sub find { shift->list->find(@_) }

sub first { shift->list->first(@_) }

sub get { shift->list->[ +shift ] }

sub last { shift->list->last }

sub push { shift->list->push(@_) }

sub to_data { shift->list->to_data }

sub reduce { shift->list->reduce(@_) }

sub size { shift->list->size }

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

See L<Mojo::Collection/each>.

=head2 C<find>

    my $element = $domain->find($id);

    # Longer version
    my $element = $domain->list->find($id);

See L<Yetie::Domain::Collection/find>.

=head2 C<first>

    my $first = $domain->first();
    my $first = $domain->first( sub {...} );

    # Longer version
    my $first = $domain->list->first();

See L<Mojo::Collection/first>.

=head2 C<get>

    my $element = $domain->get($int);

Return $element or undef.

=head2 C<last>

    my $last = $domain->last;

    # Longer version
    my $last = $domain->list->last;

See L<Mojo::Collection/last>.

=head2 C<push>

    $domain->push($element);
    $domain->push(@elements);

    # Longer version
    $domain->list->push($element);

See L<Yetie::Domain::Collection/push>.

=head2 C<to_data>

Dump the data of collection.

    my $data = $domain->to_data;

    # Longer version
    my $data = $domain->list->to_data;

Return Array reference.

=head2 C<reduce>

    my $result = $domain->reduce( sub {...} );
    my $result = $domain->reduce( sub {...}, $initial );

    # Longer version
    my $result = $domain->list->reduce();

See L<Mojo::Collection/reduce>.

=head2 C<size>

    my $size = $domain->size;

    # Longer version
    my $size = $domain->list->size;

See L<Mojo::Collection/size>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Collection>, L<Mojo::Collection>, L<Yetie::Domain::Entity>
