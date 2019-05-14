package Yetie::Domain::BaseMoo;
use Moo;
use MooX::StrictConstructor;
use strictures 2;
use namespace::clean -except => ['new','meta'];

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Base

=head1 SYNOPSIS

    package Yetie::Domain::Foo;
    use Moo;
    extends 'Yetie::Domain::Base';

    has value => ( is => 'rw' );

    sub dump { return shift->value }
    1;

=head1 DESCRIPTION

Domain object base class.

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Moo> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moo>, L<MooX::StrictConstructor>
