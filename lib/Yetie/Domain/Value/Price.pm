package Yetie::Domain::Value::Price;
use MooseX::Types::Common::Numeric qw/PositiveNum/;

use Moose;
extends 'Yetie::Domain::Value';

has '+value' => ( isa => PositiveNum );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Value::Price

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Price> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Price> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
