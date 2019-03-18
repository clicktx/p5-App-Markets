package Yetie::Domain::Value;
use Yetie::Domain::Base -readonly;
use overload
  q(bool)  => sub { 1 },
  fallback => 1;

has value => '';

sub equals {
    my ( $self, $arg ) = @_;

    my $value = ref $arg ? $arg->value : $arg;
    return $self->value eq $value ? 1 : 0;
}

sub new {
    my $class = shift;

    my $args = @_ > 1 ? {@_} : ref $_[0] ? $_[0] : {};
    return $class->SUPER::new($args);
}

sub to_data { shift->value }

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

Compare strings.

    my $bool = $obj->equals($string);

Return boolean value.

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
