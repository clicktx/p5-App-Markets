package Yetie::Domain::Value;
use Yetie::Domain::Base;
use overload
  q(bool)  => sub { 1 },
  q("")    => sub { shift->value },
  fallback => 1;

has 'value';

sub new {
    my $class = shift;

    my $args = @_ > 1 ? {@_} : ref $_[0] ? $_[0] : { value => $_[0] // '' };
    return $class->SUPER::new($args);
}

sub to_data { shift->value }

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Value

=head1 SYNOPSIS

    my $vo = Yetie::Domain::Value->new( value => 'foo' );

    my $vo = Yetie::Domain::Value->new('foo');

=head1 DESCRIPTION

=head1 FUNCTIONS

L<Yetie::Domain::Value> inherits all functions from L<Yetie::Domain::Base> and implements
the following new ones.

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

=head1 OPERATORS

L<Yetie::Domain::Value> overloads the following operators.

=head2 C<bool>

    my $bool = !!$obj;

Always true.

=head2 C<stringify>

    my $str = "$obj";

Alias for "L</value>".

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>
