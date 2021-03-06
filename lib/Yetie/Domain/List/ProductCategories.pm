package Yetie::Domain::List::ProductCategories;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

sub primary_category {
    my $self = shift;
    return $self->first( sub { shift->is_primary } );
}

sub get_form_choices_primary_category {
    my $self = shift;

    my @choices;
    $self->each(
        sub {
            push @choices, [ $_->full_title, $_->category_id, _choice_primary( $_->is_primary ) ];
        }
    );
    return \@choices;
}

sub get_id_list {
    my $self = shift;

    my @list;
    $self->each( sub { push @list, $_->category_id } );
    return \@list;
}

sub _choice_primary {
    my $is_primary = shift;
    return ( choiced => 1 ) if $is_primary;
    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::ProductCategories

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::ProductCategories> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::ProductCategories> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<primary_category>

    my $category = $categories->primary_category;

=head2 C<get_form_choices_primary_category>

    # [ [ 'foo > bar', 1, 'choiced' => 1 ], ... ]
    my $choices_data = $categories->get_form_choices_primary_category;

=head2 C<get_id_list>

    my $list = $categories->get_id_list;

Return Array reference of category ID.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
