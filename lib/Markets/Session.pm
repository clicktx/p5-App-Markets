package Markets::Session;
use Mojo::Base qw/MojoX::Session/;
use Markets::Session::Cart;
use Markets::Util qw/generate_token/;

has 'cart' => sub { Markets::Session::Cart->new( session => shift ) };
has 'cart_id' => sub { shift->data('cart_id') };

sub regenerate_session {
    my $self = shift;
    my %data = %{ $self->data };

    # Remove old session
    $self->expire;
    $self->flush;

    # Create new session
    $self->data(%data);
    $self->create;
}

sub _generate_sid {
    my $self = shift;
    $self->SUPER::_generate_sid;
    $self->data( cart_id => generate_token( length => 40 ) );
}

1;
__END__

=head1 NAME

Markets::Session - based MojoX::Session

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head2 C<cart>

    my $cart = $session->cart;

Returns new L<Markets::Session::Cart> object.

=head2 C<cart_id>

    my $cart_id = $session->cart_id;

Returns cart id.

=head2 C<regenerate_session>

    my $sid = $session->regenerate_session;

=head1 SEE ALSO

L<MojoX::Session>

L<Mojolicious>

=cut
