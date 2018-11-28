package Yetie::Domain::Entity::Page;
use Yetie::Domain::Base 'Yetie::Domain::Entity';
use Yetie::Form::Base;
use Data::Page;

has meta_title => sub { shift->page_title };
has meta_description => '';
has meta_keywords    => '';
has meta_robots      => '';
has page_title       => '';
has breadcrumbs      => sub { __PACKAGE__->factory('list-breadcrumbs')->construct() };
has form             => sub { Yetie::Form::Base->new };
has pager            => sub { Data::Page->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<meta_title>

=head2 C<meta_description>

=head2 C<meta_keywords>

=head2 C<meta_robots>

=head2 C<page_title>

    # In templates
    <%= $page->page_title %>

=head2 C<breadcrumbs>

    $page->breadcrumbs->each( sub { ... } );

Return L<Yetie::Domain::List::Breadcrumbs> object.

=head2 C<form_params>

Return L<Yetie::App::Core::Parameters> object.

NOTE: These values are validated form parameters.

=head2 C<pager>

has L<Data::Page> object.

=head1 METHODS

L<Yetie::Domain::Entity::Page> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
