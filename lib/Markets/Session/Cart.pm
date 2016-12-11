package Markets::Session::Cart;
use Mojo::Base -base;

has 'session';
has id => sub { shift->session->cart_id };

sub create { }

sub load {
    my $self = shift;
    say "   ... cart_id: " . $self->session->data('cart_id');    # debug
}

1;
__END__

=head1 NAME

Markets::Session::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head1 SEE ALSO

L<MojoX::Cart>

L<Mojolicious>

=cut
