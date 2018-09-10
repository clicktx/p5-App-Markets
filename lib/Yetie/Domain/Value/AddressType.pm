package Yetie::Domain::Value::AddressType;
use Yetie::Domain::Base 'Yetie::Domain::Value';

has [qw(id name label)];
has value => sub { shift->id };

1;
__END__

=head1 NAME

Yetie::Domain::Value::AddressType

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::AddressType> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<id>

=head2 C<name>

=head2 C<label>

=head1 METHODS

L<Yetie::Domain::Value::AddressType> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
