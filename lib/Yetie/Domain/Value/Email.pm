package Yetie::Domain::Value::Email;
use Yetie::Domain::Base 'Yetie::Domain::Value';

has is_primary  => 0;
has is_verified => 0;

1;
__END__

=head1 NAME

Yetie::Domain::Value::Email

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Email> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<is_primary>

Return boolean.

=head2 C<is_verified>

Return boolean.

=head1 METHODS

L<Yetie::Domain::Value::Email> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
