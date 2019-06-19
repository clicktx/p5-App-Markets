package Yetie::Domain::Types;
use Moose::Util::TypeConstraints;

subtype Price => (
    as 'Num',
    where { $_ > 0 },
    message { '' }
);

1;
__END__

=head1 NAME

Yetie::Domain::Types

=head1 SYNOPSIS

=head1 DESCRIPTION

This module provides a types.

=head1 C<TYPES>

=head2 C<Price>

=head1 ATTRIBUTES

=head1 METHODS

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Util::TypeConstraints>
