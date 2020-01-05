package Yetie::App::Core::TagHelpers;
use Mojo::Base 'Mojolicious::Plugin';
use Mojolicious::Plugin::TagHelpers;

sub register {
    my ( $self, $app ) = @_;

    my @helpers = (qw(button submit_button token_field));
    $app->helper( $_ => __PACKAGE__->can("_$_") ) for @helpers;
}

sub _button {
    my ( $c, $name ) = ( shift, shift );

    my $cb = ref $_[-1] eq 'CODE' ? pop : undef;
    my $content = @_ % 2 ? shift : undef;
    $content = $content // $cb // 'Ok';

    my %attrs = @_;
    my $type = $attrs{type} || 'submit';

    return _tag( 'button', name => $name, type => $type, @_, $content );
}

sub _submit_button {
    my ( $c, $value ) = ( shift, shift // 'Ok' );

    my %attrs = @_;
    my $type = $attrs{type} || 'submit';
    _tag( 'input', type => $type, value => $value, @_ );
}

sub _tag { Mojolicious::Plugin::TagHelpers::_tag(@_) }

sub _token_field {
    my $c    = shift;
    my %args = @_;

    $args{token} = $c->helpers->token->get if !$args{token};
    return $c->helpers->hidden_field(%args);
}

1;
__END__

=head1 NAME

Yetie::App::Core::TagHelpers - Tag helpers plugin for Yetie

=head1 DESCRIPTION

=head1 HELPERS

L<Yetie::App::Core::TagHelpers> implements the following helpers.

=head2 C<button>

    %= button 'story'
    %= button 'story', type => 'button'
    %= button story => 'Reset', type => 'reset'
    %= button story => 'Default', value => 'never'
    %= button story => (type => 'button') => begin
        Default
    % end

Generate C<button> tag.

    <button name="story" type="submit">Ok</button>
    <button name="story" type="button">Ok</button>
    <button name="story" type="reset">Reset</button>
    <button name="story" type="submit" value="never">Default</button>
    <button name="story" type="button">
        Default
    </button>

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

=head2 C<token_field>

    %= token_field

    %= token_field( token => 'foobarbaz' )

Generate input tag of type hidden with L<Yetie::App::Core::DefaultHelpers/token>.

    <input name="token" type="hidden" value="fa6a08...">

    <input name="token" type="hidden" value="foobarbaz">

=head1 AUTHOR

Yetie authors.
