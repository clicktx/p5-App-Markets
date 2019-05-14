package Yetie::Domain::Value;
use Moo;
use Mojo::Util qw();

extends 'Yetie::Domain::BaseMoo';

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

sub equals {
    my ( $self, $obj ) = @_;
    return $self->hash_code eq $obj->hash_code ? 1 : 0;
}

sub hash_code {
    my $self = shift;

    my %attrs = %{$self};
    my @keys  = keys %attrs;
    my $str;
    foreach my $key ( sort @keys ) {

        # private attribute
        next if $key =~ /\A_.*/sxm;

        $str .= "$key:$attrs{$key},";
    }
    return Mojo::Util::sha1_sum($str);
}

sub to_data { return shift->value }

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

=head2 C<to_data>

    my $value = $obj->to_data;

L</value> alias method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>, L<Moo>
