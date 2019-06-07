package Yetie::Domain::Value::Token;
use Moose;
extends 'Yetie::Domain::Value';

use Yetie::Util qw(uuid);

has '+value' => ( default => sub { uuid() } );

1;
__END__

=head1 NAME

Yetie::Domain::Value::Token

=head1 SYNOPSIS

=head1 DESCRIPTION

    # Create new token
    my $token = Yetie::Domain::Value::Token->new;

    # Set token
    my $token = Yetie::Domain::Value::Token->new( value => $token );

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Token> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Token> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>, L<Moose>
