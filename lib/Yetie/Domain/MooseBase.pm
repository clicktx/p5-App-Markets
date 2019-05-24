package Yetie::Domain::MooseBase;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

sub get_all_attribute_names {
    return ( sort map { $_->name } shift->meta->get_all_attributes );
}

sub get_public_attribute_names {
    return ( grep { /\A(?!_).*/sxm } shift->get_all_attribute_names );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Base

=head1 SYNOPSIS

    package Yetie::Domain::Foo;
    use Moose;
    extends 'Yetie::Domain::Base';

    has foo => ( is => 'ro' );

    no Moose;
    __PACKAGE__->meta->make_immutable;
    1;

=head1 DESCRIPTION

Domain object base class.

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Moose> and implements
the following new ones.

=head2 C<get_all_attribute_names>

    my @names = $obj->get_all_attribute_names;

Return all attribute name list.

=head2 C<get_public_attribute_names>

    my @names = $obj->get_public_attribute_names;

Return all public attribute name list.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose>, L<MooseX::StrictConstructor>
