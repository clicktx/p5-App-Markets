package Yetie::Domain::Entity::Content;
use Yetie::Domain::Entity;
use Yetie::Domain::Collection;
use Yetie::Parameters;
use Data::Page;

has title       => '';
has description => '';
has keywords    => '';
has robots      => '';

has breadcrumb => sub { Yetie::Domain::Collection->new };
has pager      => sub { Data::Page->new };
has params     => sub { Yetie::Parameters->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Content

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Content> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<keywords>

=head2 C<robots>

=head2 C<breadcrumb>

    $content->breadcrumb->each( sub { ... } );

has L<Yetie::Domain::Entity::Link> object in L<Yetie::Domain::Collection> object.

=head2 C<pager>

has L<Data::Page> object.

=head2 C<params>

Return L<Yetie::Parameters> object.

NOTE: These values are validated form parameters.

=head1 METHODS

L<Yetie::Domain::Entity::Content> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
