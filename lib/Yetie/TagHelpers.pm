package Yetie::TagHelpers;
use Mojo::Base 'Mojolicious::Plugin';
use Mojolicious::Plugin::TagHelpers;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( submit_button => __PACKAGE__->can("_submit_button") );
}

sub _submit_button {
    my ( $c, $value ) = ( shift, shift // 'Ok' );

    my %attrs = @_;
    my $type = %attrs{type} || 'submit';
    return Mojolicious::Plugin::TagHelpers::_tag( 'input', value => $value, @_, type => $type );
}

1;
__END__

=head1 NAME

Yetie::TagHelpers - Tag helpers plugin for Yetie

=head1 DESCRIPTION

=head1 HELPERS

L<Yetie::TagHelpers> implements the following helpers.

=head2 C<submit_button>

Override method for L<Mojolicious::Plugin::TagHelpers/submit_button>.

    %= submit_button
    %= submit_button 'Ok!', id => 'foo'
    %= submit_button 'Go!', type => 'button'
    %= submit_button 'Reset', type => 'reset'

Generate C<input> tag of type C<submit>(default).

    <input type="submit" value="Ok">
    <input id="foo" type="submit" value="Ok!">
    <input type="button" value="Go!">
    <input type="reset" value="Reset">

=head1 AUTHOR

Yetie authors.
