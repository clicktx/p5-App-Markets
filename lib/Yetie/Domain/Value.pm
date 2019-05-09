package Yetie::Domain::Value;
use Yetie::Domain::Base -readonly;
use Mojo::Util qw();
use overload
  q(bool)  => sub { 1 },
  fallback => 1;

has value => '';

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

sub new {
    my $class = shift;

    my $args = @_ > 1 ? {@_} : ref $_[0] ? $_[0] : {};
    return $class->SUPER::new($args);
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

=head1 FUNCTIONS

L<Yetie::Domain::Value> inherits all functions from L<Yetie::Domain::Base> and implements
the following new ones.

=head1 ATTRIBUTES

L<Yetie::Domain::Value> inherits all attributes from L<Yetie::Domain::Base> and implements
the following new ones.

The value can not be set.This object is immutable.

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

=head1 OPERATORS

L<Yetie::Domain::Value> overloads the following operators.

=head2 C<bool>

    my $bool = !!$obj;

Always true.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>
