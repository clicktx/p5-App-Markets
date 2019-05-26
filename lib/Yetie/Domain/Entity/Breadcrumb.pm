package Yetie::Domain::Entity::Breadcrumb;
use Mojo::URL;

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has class => ( is => 'ro', default => '' );
has title => ( is => 'ro', default => '' );
has url   => ( is => 'ro', default => sub { Mojo::URL->new } );

no Moose;
__PACKAGE__->meta->make_immutable;

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
