package Yetie::Domain::Role::TypesMoney;
use Moose::Role;
use Moose::Util::TypeConstraints;

enum CurrencyCode => [qw(EUR GBP JPY USD)];

enum RoundMode => [qw(even odd +inf -inf zero trunc)];

1;
__END__
=for stopwords +inf -inf trunc

=head1 NAME

Yetie::Domain::Role::TypesMoney

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBTYPES

=head2 C<CurrencyCode>

enum 'EUR', 'GBP', 'JPY', 'USD'

=head2 C<RoundMode>

enum 'even', 'odd', '+inf', '-inf', 'zero', 'trunc'

=head1 ATTRIBUTES

L<Yetie::Domain::Role::TypesMoney> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Role::TypesMoney> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
