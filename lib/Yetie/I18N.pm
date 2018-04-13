package Yetie::I18N;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = @_;

    $app->plugin( 'Yetie::I18N::LocaleTextDomainOO', $conf );

    # loading lexicon files
    my $locale_dir = $app->home->child( 'share', 'locale' );
    $app->lexicon(
        {
            search_dirs => [ $locale_dir, $locale_dir->child('messages') ],

            # gettext_to_maketext => $boolean,                    # option
            # decode              => $boolean,                    # option
            data => [ '*::' => '*.po' ],
        }
    ) if -d $locale_dir;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::I18N

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::I18N');

    # Mojolicious::Lite
    plugin 'Yetie::I18N';

=head1 DESCRIPTION

=head1 METHODS

L<Yetie::I18N> inherits all methods from L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Yetie::I18N::LocaleTextDomainOO>, L<Mojolicious::Plugin>

=cut
