package Yetie::App::Core::Currency;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = ( shift, shift, shift || {} );

    # Initialize
    my $currency = Yetie::App::Core::Currency::Object->new($conf);
    $currency->init;

    # Attributes
    $app->attr( currency => sub { $currency } );
}

package Yetie::App::Core::Currency::Object;
use Mojo::Base -base;
use Math::Currency;

has default_format     => 'USD';
has default_round_mode => 'even';

sub init {
    my $self = shift;

    $self->set_format( $self->default_format );
    $self->set_round_mode( $self->default_round_mode );
    return;
}

sub revert_format {
    my $self = shift;

    Math::Currency->format( $self->default_format );
    return;
}

sub revert_round_mode {
    my $self = shift;

    Math::Currency->round_mode( $self->default_round_mode );
    return;
}

sub set_format {
    my ( $self, $format ) = @_;

    Math::Currency->format($format);
    return;
}

sub set_round_mode {
    my ( $self, $mode ) = @_;

    Math::Currency->round_mode($mode);
    return;
}

1;

=encoding utf8

=head1 NAME

Yetie::App::Core::Currency

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::App::Core::Currency> inherits all attributes.

=head2 C<currency>

    my $currency = $app->currency;

Return L<Yetie::App::Core::Currency::Object>

=head1 METHODS

L<Yetie::App::Core::Currency> inherits all methods.

=head2 C<set_format>

    $app->currency->set_format('USD');

Change the currency format of the application.

NOTE: Use the L</revert_format> method to revert the default.

=head2 C<set_round_mode>

    $app->currency->set_round_mode('even');

Change the application rounding.

NOTE: Use the L</revert_round_mode> method to revert the default.

=head2 C<revert_format>

    $app->currency->format;

Revert application currency format to default settings.

=head2 C<revert_round_mode>

    $app->currency->revert_round_mode;

Revert application rounding to default settings.

=head1 SEE ALSO

L<Math::Currency>

=cut
