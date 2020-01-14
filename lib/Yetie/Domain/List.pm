package Yetie::Domain::List;
use Yetie::Domain::Collection;
use Yetie::Util qw(args2hash);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has list => (
    is      => 'rw',
    isa     => 'Yetie::Domain::Collection',
    default => sub { Yetie::Domain::Collection->new }
);

sub append {
    my $self = shift;
    my $new  = $self->list->append(@_);
    $self->list($new);
    return;
}

sub append_new {
    my ( $self, $domain, @args ) = @_;
    my $args = args2hash(@args);

    my $obj = $self->factory($domain)->construct($args);
    $self->append($obj);
    return $obj;
}

sub clear { return shift->list( Yetie::Domain::Collection->new ) }

sub each {
    my ( $self, $cb ) = @_;
    return @{ $self->list } if !$cb;

    $self->list->each($cb);
    return $self;
}

sub first { return shift->list->first(@_) }

sub get { return shift->list->get(shift) }

sub get_by_id { return shift->list->get_by_id(shift) }

sub get_by_line_num { return shift->list->get_by_line_num(shift) }

sub grep { return shift->list->grep(@_) }

sub has_elements { return shift->list->size ? 1 : 0 }

sub last { return shift->list->last }

sub map { return shift->list->map(@_) }

sub reduce {
    my $self = shift;
    @_ = ( @_, @{ $self->list } );
    goto &List::Util::reduce;
}

sub size { return shift->list->size }

sub to_array { return shift->list->to_array }

sub to_data { return shift->list->to_data }

sub to_order_data { return shift->list->to_order_data }

no Moose;
__PACKAGE__->meta->make_immutable;

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

=head2 C<append>

    $domain->append($element);
    $domain->append(@elements);

See L<Yetie::Domain::Collection/append>.

Return C<undefined>

=head2 C<append_new>

    my $new_entity_obj = $domain->append_new( 'entity-foo', %args );

    my $new_value_obj = $domain->append_new( 'value-bar' => \%args );

    $domain->append_new( 'entity-foo' => { id => 'bar', title => 'baz' } );

Create new domain object and append for L</list>.

Return created new domain object.

=head2 C<clear>

    $domain->clear;

Clear collection.

Create empty collection in L</list>.

=head2 C<each>

    $domain->each( sub{ ... } );

    # Longer version
    $domain->list->each( sub{ ... } );

See L<Mojo::Collection/each>.

=head2 C<first>

    my $first = $domain->first();
    my $first = $domain->first( sub {...} );

    # Longer version
    my $first = $domain->list->first();

See L<Mojo::Collection/first>.

=head2 C<get>

    my $element = $domain->get($index);

Return $element or undef.

See L<Yetie::Domain::Collection/get>.

=head2 C<get_by_id>

    my $element = $domain->get_by_id($element_id);

    # Longer version
    my $element = $domain->list->get_by_id($element_id);

See L<Yetie::Domain::Collection/get_by_id>.

=head2 C<get_by_line_num>

    my $element = $domain->get_by_line_num($line_num);

Return $element or undef.

See L<Yetie::Domain::Collection/get_by_line_num>.

=head2 C<grep>

    my $new = $domain->grep(q/foo/);

    # Longer version
    my $new = $domain->list->grep(q/foo/);

See L<Mojo::Collection/grep>

=head2 C<has_elements>

Returns true if there is an element.

    my $bool = $domain->has_elements;

Return boolean value.

=head2 C<last>

    my $last = $domain->last;

    # Longer version
    my $last = $domain->list->last;

See L<Mojo::Collection/last>.

=head2 C<map>

    my $new = $domain->map( sub {...} );

    # Longer version
    my $new = $domain->list->map( sub {...} );

See L<Mojo::Collection/map>

=head2 C<reduce>

    my $result = $domain->reduce( sub {...} );

    # Longer version
    my $result = $domain->list->reduce( sub {...} );

See L<Mojo::Collection/reduce>

=head2 C<size>

    my $size = $domain->size;

    # Longer version
    my $size = $domain->list->size;

See L<Mojo::Collection/size>

=head2 C<to_array>

    my $arrayref = $domain->to_array;

    # Longer version
    my $arrayref = $domain->list->to_array;

Return Array reference.

See L<Mojo::Collection/to_array>.

=head2 C<to_data>

Dump the data of collection.

    my $data = $domain->to_data;

    # Longer version
    my $data = $domain->list->to_data;

Return Array reference.

NOTE: Dump all object recursively.

=head2 C<to_order_data>

L</to_data> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Collection>, L<Mojo::Collection>, L<Yetie::Domain::Entity>
