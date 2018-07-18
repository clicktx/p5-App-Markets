package Yetie::Domain::Value;
use Mojo::Base -base;
use overload
  q(bool)  => sub { 1 },
  q("")    => sub { shift->value },
  fallback => 1;

has value => '';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    return $self;
}

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Value

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

L<Yetie::Domain::Value> inherits all functions from L<Mojo::Base> and implements
the following new ones.

=head1 ATTRIBUTES

L<Yetie::Domain::Value> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 C<value>

    my $value = $obj->value;

=head1 METHODS

L<Yetie::Domain::Value> inherits all methods from L<Mojo::Base> and implements
the following new ones.

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

L<Mojo::Base>
