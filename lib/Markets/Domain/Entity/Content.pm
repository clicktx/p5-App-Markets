package Markets::Domain::Entity::Content;
use Markets::Domain::Entity;
use Data::Page;

has title       => '';
has description => '';
has keywords    => '';
has robots      => '';

has breadcrumb => sub { Markets::Domain::Collection->new };
has pager      => sub { Data::Page->new };
has params     => sub { {} };

1;
__END__

=head1 NAME

Markets::Domain::Entity::Content

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Content> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<keywords>

=head2 C<robots>

=head2 C<breadcrumb>

    $content->breadcrumb->each( sub { ... } );

has L<Markets::Domain::Entity::Breadcrumb> object in L<Markets::Domain::Collection> object.

=head2 C<pager>

has L<Data::Page> object.

=head2 C<params>

Return hash refference.This values is validated form parameters.

=head1 METHODS

L<Markets::Domain::Entity::Content> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
