package Yetie::Domain::Role::Types;
use Moose::Role;
use Moose::Util::TypeConstraints;

enum RoundMode => [qw/even odd +inf -inf zero trunc/];

1;
__END__

=head1 NAME

Yetie::Domain::Role::Types

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBTYPES

=head2 C<RoundMode>

enum 'even', 'odd', '+inf', '-inf', 'zero', 'trunc'

=head1 ATTRIBUTES

L<Yetie::Domain::Role::Types> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Role::Types> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
