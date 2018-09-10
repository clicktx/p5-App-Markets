package Yetie::Domain::Entity::Page::Category;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has level     => 0;
has root_id   => 0;
has title     => '';
has products  => sub { Yetie::Domain::Collection->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page::Category> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head2 C<products>

Return L<Yetie::Schema::ResultSet::Product> object or C<undefined>.

=head1 METHODS

L<Yetie::Domain::Entity::Page::Category> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
