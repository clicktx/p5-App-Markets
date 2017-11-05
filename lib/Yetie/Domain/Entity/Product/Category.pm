package Yetie::Domain::Entity::Product::Category;
use Yetie::Domain::Entity;

has id => sub { shift->category_id };
has category_id => 0;
has is_primary  => 0;
has title       => '';

sub to_hash {
    my $self = shift;

    my $hash = $self->SUPER::to_hash;
    delete $hash->{title};
    return $hash;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Product::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Product::Category> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<id>

=head2 C<category_id>

=head2 C<is_primary>

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Entity::Product::Category> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
