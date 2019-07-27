package Yetie::Schema::ResultSet::Category;
use Mojo::Base 'Yetie::Schema::ResultSet';
use Carp qw(croak);

sub create_category {
    my ( $self, $title, $parent_id ) = @_;
    return if !$title;

    my $result;
    if ($parent_id) {

        # Create child node
        my $parent = $self->find($parent_id) || return;
        $result = $parent->add_to_children( { title => $title } );
    }
    else {
        # Create root node
        $result = $self->create( { title => $title } );
    }

    return $result;
}

sub has_title {
    my ( $self, $title, $parent_id ) = @_;
    croak 'Argument empty' if !$title;

    my $where = { title => $title };
    if ($parent_id) {
        $where->{root_id} = $parent_id;
        $where->{level} = { '!=' => 0 };
    }
    else {
        $where->{level} = 0;
    }

    my $result = $self->find($where);
    return $result ? 1 : 0;
}

sub update_category {
    my ( $self, $entity, $option ) = @_;
    my $cols = [ qw(title), @{$option} ];

    my $data = {};
    $data->{$_} = $entity->$_ for @{$cols};

    $self->search( { id => $entity->id } )->update($data);
    return $self;
}

sub _tree {
    my ( $root, $ids ) = @_;

    my @tree;
    my $itr = $root->nodes;
    while ( my $node = $itr->next ) {
        my $title = '¦   ' x $node->level . $node->title;
        push @tree, [ $title, $node->id, _choiced( $node->id, $ids ) ];
    }
    return \@tree;
}

sub _choiced {
    my ( $id, $ids ) = @_;

    foreach my $v ( @{$ids} ) {
        return ( choiced => 1 ) if $v == $id;
    }
    return;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Category

=head1 SYNOPSIS

    my $result = $schema->resultset('Category')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Category> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Category> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<create_category>

    # Create root category
    my $result = $rs->create_category($title);

    # Create children category
    my $result = $rs->create_category($title, $parent_id);

Create category.

Return Value: L<$result|DBIx::Class::Manual::ResultClass> | undef

=head2 C<has_title>

    my $bool = $rs->has_title($title);
    my $bool = $rs->has_title($title, $parent_id);

    if ($bool){ say "$title exsts" }

Return Boolean value.

=head2 C<update_category>

    $rs->update_category( $entity, \@option );

    $rs->update_category( $entity, [ 'column_foo', 'colmun_bar' ] );

Update category using entity data.
Add a column to be updated with the second argument.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
