package Yetie::Domain::Value;
use Moose;
extends 'Yetie::Domain::MooseBase';

has value => (
    is      => 'ro',
    default => q{},
);

# Do not created an undefined attribute "value"
around BUILDARGS => sub {
    ( shift, shift );    # $orig, $class
    my %args = @_ ? @_ > 1 ? @_ : %{ $_[0] } : ();

    if ( !defined $args{value} ) { delete $args{value} }
    return \%args;
};

sub to_data { return shift->value }

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

Yetie::Domain::Value

=head1 SYNOPSIS

    my $vo = Yetie::Domain::Value->new( value => 'foo' );

=head1 DESCRIPTION

Immutable value object base class.

=head1 ATTRIBUTES

L<Yetie::Domain::Value> inherits all attributes from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<value>

    my $value = $obj->value;

=head1 METHODS

L<Yetie::Domain::Value> inherits all methods from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<to_data>

    my $value = $obj->to_data;

L</value> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>, L<Moose>
__PACKAGE__->meta->make_immutable;
__PACKAGE__->meta->make_immutable;
