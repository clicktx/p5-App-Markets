package Yetie::Domain::Value::Tax;
use Moose;
extends 'Yetie::Domain::Value::Price';

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Yetie::Domain::Value::Tax

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Tax> inherits all attributes from L<Yetie::Domain::Value::Price> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Tax> inherits all methods from L<Yetie::Domain::Value::Price> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value::Price>, L<Math::Currency>, L<Yetie::Domain::Value>
