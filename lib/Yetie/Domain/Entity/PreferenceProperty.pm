package Yetie::Domain::Entity::PreferenceProperty;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has [qw/name default_value title summary position group_id/] => ( is => 'ro' );
has value => ( is => 'rw' );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::PreferenceProperty

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::PreferenceProperty> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 c<name>

=head2 c<value>

=head2 c<default_value>

=head2 c<title>

=head2 c<summary>

=head2 c<position>

=head2 c<group_id>

=head1 METHODS

L<Yetie::Domain::Entity::PreferenceProperty> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
