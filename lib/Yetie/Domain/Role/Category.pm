package Yetie::Domain::Role::Category;
use Moose::Role;

has level   => ( is => 'ro', default => 0 );
has root_id => ( is => 'ro', default => 0 );
has title   => (
    is      => 'rw',
    default => q{},
);

1;
__END__

=head1 NAME

Yetie::Domain::Role::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Role::Category> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Role::Category> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
