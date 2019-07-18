package Yetie::Domain::Entity::CategoryTreeRoot;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with qw(Yetie::Domain::Role::CategoryChild);

has _index => (
    traits     => ['Hash'],
    is         => 'ro',
    isa        => 'HashRef[Yetie::Domain::Entity::CategoryTreeNode]',
    lazy_build => 1,
    writer     => 'set_index',
);

sub create_index {
    my $self  = shift;
    my $index = _create_index($self);
    $self->set_index($index);
    return;
}

sub get_attributes_for_choices_form {
    my ( $self, $ids ) = @_;

    my @array;
    $self->children->each(
        sub {
            push @array, _choice_property( $_, $ids );
            push @array, @{ get_attributes_for_choices_form( $_, $ids ) };
        }
    );
    return \@array;
}

sub get_node {
    my ( $self, $id ) = ( shift, shift // q{} );
    return $self->_index->{$id};
}

sub _build__index {
    my $self = shift;
    return _create_index($self);
}

sub _choice_property {
    my ( $node, $ids ) = @_;

    # my $title = ' ' . '-' x $node->level . ' ' . $node->title;
    my $title = $node->title;
    my @data = ( $title, $node->id );
    foreach my $id ( @{$ids} ) {
        if ( $id == $node->id ) { push @data, ( 'choiced' => 1 ) }
    }
    return \@data;
}

sub _create_index {
    my $obj = shift;

    my %index;
    $obj->children->each(
        sub {
            $index{ $_->id } = $_;
            if ( $_->has_child ) {
                my $res = _create_index($_);
                %index = ( %index, %{$res} );
            }
        }
    );
    return \%index;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTreeRoot

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all attributes from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryChild>

and implements the following new ones.

=head2 C<children>

Inherits from L<Yetie::Domain::Role::CategoryChild>

    my $children = $category_root->children;

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all methods from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryChild>

and implements the following new ones.

=head2 C<create_index>

    $categoty_root->create_index;

Create and re-create category index from L</children>.

=head2 C<get_attributes_for_choices_form>

    # [ [ 'cate1', 1, 'choiced', 1 ], [ 'cate2', 2, 'choiced', 1 ], [ 'cate3', 3 ], ... ]
    my $array_ref = $category_root->get_attributes_for_choices_form( [ 1, 2 ] );

Return Array reference.

Attributes for L<Yetie::Form::Field/choices>.

=head2 C<get_node>

    my $node = $categoty_root->get_node($category_id);

Return L<Yetie::Domain::Entity::CategoryTreeNode> object.

=head2 C<has_child>

Inherits from L<Yetie::Domain::Role::CategoryChild>

    my $bool = $category_root->has_child;

Return boolean value.

=head2 C<set_index>

    my %category_index = ( 1 => Yetie::Domain::Entity::CategoryTreeNode->new, ... );
    $category_root->set_index(\%category_index);

Set to attribute C<_index>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Role::CategoryChild>, L<Yetie::Domain::Entity>
