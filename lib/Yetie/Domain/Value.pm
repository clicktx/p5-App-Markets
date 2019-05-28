package Yetie::Domain::Value;
use Data::Dumper;

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseBase';

has _hash_sum => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);
sub _build__hash_sum { return shift->hash_code }

has value => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => q{},
);

# Do not created an undefined attribute "value"
around BUILDARGS => sub {
    ( shift, shift );    # $orig, $class
    my %args = @_ ? @_ > 1 ? @_ : %{ $_[0] } : ();

    if ( !defined $args{value} ) { delete $args{value} }
    return \%args;
};

sub BUILD {
    my $self = shift;

    # Lazy build
    $self->_hash_sum;
}

sub equals {
    my ( $self, $obj ) = @_;
    return $self->hash_code eq $obj->hash_code ? 1 : 0;
}

sub hash_code { return Mojo::Util::sha1_sum( shift->_dump_public_attr ) }

sub is_modified {
    my $self = shift;
    return $self->_hash_sum ne $self->hash_code ? 1 : 0;
}

sub to_data { return shift->value }

sub _dump_public_attr {
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = sub {
        my ($hash) = @_;
        my @keys = grep { /\A(?!_).*/sxm } ( sort keys %{$hash} );
        return \@keys;
    };
    return Dumper(shift);
}

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

=head2 C<equals>

    my $bool = $obj->equals($object);

Return boolean value.

=head2 C<hash_code>

    # "960167e90089e5ebe6a583e86b4c77507afb70b7"
    my $sha1_sum = $obj->hash_code;

Return sha1 string.

=head2 C<is_modified>

    my $bool = $obj->is_modified;

=head2 C<to_data>

    my $value = $obj->to_data;

L</value> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>, L<Moose>
