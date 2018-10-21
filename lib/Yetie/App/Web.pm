package Yetie::App::Web;
use Mojo::Base 'Yetie::App::Common';
use Yetie::Util qw/directories/;

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # Template paths
    $self->renderer->paths( [ 'themes/default', 'themes/admin' ] );

    # debug User themes
    my $themes = directories( 'themes', { ignore => [ 'admin', 'common', 'default' ] } );
    say $self->dumper($themes);

    # unshift @{$self->renderer->paths}, 'themes/mytheme';
    push @{ $self->renderer->paths }, 'themes';    # For template full path

    # [WIP]loading lexicon files from themes
    my $theme_locale_dir = $self->home->child( 'themes', 'default', 'locale' );
    $self->lexicon(
        {
            search_dirs => [$theme_locale_dir],
            data        => [ '*:theme:' => '*.po' ]
        }
    ) if -d $theme_locale_dir;

    # [WIP] Merge lexicon
    # my $locale_files = Mojo::File->new($theme_locale_dir)->list;    # return Mojo::Collection Object
    # $locale_files->each(
    #     sub {
    #         my ( $e, $num ) = @_;
    #         say "$num: $e";
    #     }
    # );
    my $instance = Locale::TextDomain::OO::Singleton::Lexicon->instance;
    eval {
        $instance->merge_lexicon( 'en::', 'en:theme:', 'en::' );    # [WIP]
        $instance->merge_lexicon( 'ja::', 'ja:theme:', 'ja::' );    # [WIP]
    };

    # Renderer
    $self->plugin($_) for qw(Yetie::App::Core::View::EPRenderer Yetie::App::Core::View::EPLRenderer Yetie::App::Core::View::DOM);

    # Initialize all addons
    my $installed_addons = $self->schema->resultset('addon')->configure;
    $self->addons->init($installed_addons) unless $ENV{MOJO_ADDON_TEST_MODE};

    # Routes
    $self->plugin($_) for qw(Yetie::Routes);

    # Form Framework
    $self->plugin('Yetie::App::Core::Form');
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::App::Web

=head1 SYNOPSIS



=head1 DESCRIPTION



=head1 ATTRIBUTES

L<Yetie::App::Web> inherits all attributes from L<Yetie::App::Common> and implements
the following new ones.

=head1 METHODS

L<Yetie::App::Web> inherits all methods from L<Yetie::App::Common> and implements
the following new ones.

=head2 C<startup>

=head1 SEE ALSO

L<Yetie::App::Common>

=cut
