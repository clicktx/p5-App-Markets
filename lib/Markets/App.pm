package Markets::App;
use Mojo::Base 'Markets::App::Common';
use Markets::Util qw/directories/;

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # Template paths
    $self->renderer->paths( [ 'themes/default', 'themes/admin' ] );

    # Original themes
    my $themes = directories( 'themes', { ignore => [ 'default', 'admin' ] } );
    say $self->dumper($themes);    # debug

    # [WIP]loading lexicon files from themes
    my $theme_locale_dir = Mojo::File::path( $self->home, 'themes', 'default', 'locale' );
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

    # unshift @{$self->renderer->paths}, 'themes/mytheme';
    push @{ $self->renderer->paths }, 'themes';                     # For template full path

    # Renderer
    $self->plugin($_)
      for qw(Markets::View::EPRenderer Markets::View::EPLRenderer Markets::View::DOM);

    # Initialize all addons
    my $installed_addons = $self->model('addon')->configure;
    $self->addons->init($installed_addons) unless $ENV{MOJO_ADDON_TEST_MODE};

    # Routes
    $self->plugin($_) for qw(Markets::Routes);
}

1;
