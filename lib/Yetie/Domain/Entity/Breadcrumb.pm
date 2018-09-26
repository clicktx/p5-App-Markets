package Yetie::Domain::Entity::Breadcrumb;
use Yetie::Domain::Base 'Yetie::Domain::Entity';
use Mojo::URL;

has class => '';
has title => '';
has url   => sub { Mojo::URL->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Breadcrumb

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Breadcrumb> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<class>

=head2 C<title>

=head2 C<url>

Returns L<Mojo::URL> object.

=head1 METHODS

L<Yetie::Domain::Entity::Breadcrumb> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
