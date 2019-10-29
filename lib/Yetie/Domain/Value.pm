package Yetie::Domain::Value;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Base';

with qw(MooseX::Clone);

has value => (
    is      => 'ro',
    isa     => 'Str',
    default => q{},
);

around BUILDARGS => sub {
    my ( $orig, $class ) = ( shift, shift );

    if ( @_ == 1 && !ref $_[0] ) {
        return $class->$orig( value => $_[0] );
    }
    else {
        return $class->$orig(@_);
    }
};

around clone => sub {
    my ( $orig, $class, %params ) = @_;

    my $clone = $class->$orig(%params);
    return $clone->rehash;
};

sub equals {
    my ( $self, $obj ) = @_;
    return $self->hash_code eq $obj->hash_code ? 1 : 0;
}

sub is_modified {
    my $self = shift;
    return $self->_hash_sum ne $self->hash_code ? 1 : 0;
}

sub to_data { return shift->value }

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

Yetie::Domain::Value

=head1 SYNOPSIS

    my $vo = Yetie::Domain::Value->new( value => 'foo', ... );

    # Single argument
    my $vo = Yetie::Domain::Value->new('foo');
    # foo
    say $vo->value;

=head1 DESCRIPTION

Immutable value object base class.

=head1 ATTRIBUTES

L<Yetie::Domain::Value> inherits all attributes from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<value>

Read only

    my $value = $obj->value;

=head1 METHODS

L<Yetie::Domain::Value> inherits all methods from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<clone>

    my $clone = $obj->clone(%params);

=head2 C<equals>

    my $bool = $obj->equals($object);

Return boolean value.

=head2 C<is_modified>

    my $bool = $obj->is_modified;

=head2 C<to_data>

    my $value = $obj->to_data;

L</value> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>, L<Moose>
