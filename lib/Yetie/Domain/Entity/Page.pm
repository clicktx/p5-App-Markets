package Yetie::Domain::Entity::Page;
use Yetie::Form::Base;
use Data::Page;

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has meta_info => (
    is      => 'ro',
    default => sub {
        {
            title       => sub { shift->title },
            description => q{},
            keywords    => q{},
            robots      => q{}
        };
    }
);

has title => ( is => 'rw', default => q{} );

has breadcrumbs => (
    is      => 'ro',
    lazy    => 1,
    default => sub { __PACKAGE__->factory('list-breadcrumbs')->construct() }
);

has form => (
    is      => 'ro',
    lazy    => 1,
    default => sub { Yetie::Form::Base->new }
);

has pager => (
    is      => 'ro',
    lazy    => 1,
    default => sub { Data::Page->new }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<meta_info>

=head2 C<title>

    # In templates
    <%= $page->title %>

=head2 C<breadcrumbs>

    $page->breadcrumbs->each( sub { ... } );

Return L<Yetie::Domain::List::Breadcrumbs> object.

=head2 C<form>

=head2 C<pager>

has L<Data::Page> object.

=head1 METHODS

L<Yetie::Domain::Entity::Page> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
