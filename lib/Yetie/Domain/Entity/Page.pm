package Yetie::Domain::Entity::Page;
use Yetie::Domain::Entity;
use Yetie::Domain::Collection;
use Yetie::Form::Base;
use Data::Page;

has title       => '';
has description => '';
has keywords    => '';
has robots      => '';
has breadcrumb  => sub { Yetie::Domain::Collection->new };
has form        => sub { Yetie::Form::Base->new };
has pager       => sub { Data::Page->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<keywords>

=head2 C<robots>

=head2 C<breadcrumb>

    $content->breadcrumb->each( sub { ... } );

has L<Yetie::Domain::Entity::Link> object in L<Yetie::Domain::Collection> object.

=head2 C<form_params>

Return L<Yetie::Parameters> object.

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
