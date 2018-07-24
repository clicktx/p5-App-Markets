package Yetie::Domain::Value::Phone;
use Mojo::Base 'Yetie::Domain::Value';

sub number_only {
    local $_ = shift->value;
    s/\D//g;
    $_;
}

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Value::Phone

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

L<Yetie::Domain::Value::Phone> inherits all functions from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Phone> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Phone> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
