package Yetie::Cache;
use Mojo::Base 'Mojo::Cache';

sub clear_all {
    my $self = shift;

    $self->{cache} = {};
    $self->{queue} = [];
    return $self;
}

1;

=encoding utf8

=head1 NAME

Yetie::Cache

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Cache> inherits all attribures from L<Mojo::Cache> and implements the
following new ones.

=head1 METHODS

L<Yetie::Cache> inherits all methods from L<Mojo::Cache> and implements the
following new ones.

=head2 C<clear_all>

    $cache->clear_all;

Clear all caches.

=head1 SEE ALSO

L<Mojo::Cache>

=cut
