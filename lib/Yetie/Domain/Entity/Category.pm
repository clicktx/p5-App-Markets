package Yetie::Domain::Entity::Category;
use Yetie::Domain::Entity;
use Yetie::Domain::Collection;

has breadcrumb => sub { Yetie::Domain::Collection->new };
has 'products';
has title   => '';

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Category> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<breadcrumb>

Return L<Yetie::Domain::Collection> object.

=head2 C<products>

Return L<Yetie::Schema::ResultSet::Product> object or C<undefined>.

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Entity::Category> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
