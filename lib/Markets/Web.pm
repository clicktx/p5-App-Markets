package Markets::Web;
use Mojo::Base 'Markets::Core';
use Markets::Util qw/directories/;
use Mojo::Util qw/files/;

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
    my $theme_locale_dir =
      File::Spec->catdir( $self->home, 'themes', 'default', 'locale' );
    $self->lexicon(
        {
            search_dirs => [$theme_locale_dir],
            data        => [ '*:theme:' => '*.po' ]
        }
    ) if -d $theme_locale_dir;

    # [WIP] Merge lexicon
    my @locale_files = files "$theme_locale_dir";   # map {say $_}@locale_files;
    my $instance = Locale::TextDomain::OO::Singleton::Lexicon->instance;
    eval {
        $instance->merge_lexicon( 'en::', 'en:theme:', 'en::' );    # [WIP]
        $instance->merge_lexicon( 'ja::', 'ja:theme:', 'ja::' );    # [WIP]
    };

    # unshift @{$self->renderer->paths}, 'themes/mytheme';
    push @{ $self->renderer->paths }, 'themes';    # For template full path

    # renderer
    $self->plugin('Markets::Plugin::EPRenderer');
    $self->plugin('Markets::Plugin::EPLRenderer');
    $self->plugin('Markets::Plugin::DOM');

    # Routes
    $self->plugin('Markets::Web::Admin::Routes');
    $self->plugin('Markets::Web::Catalog::Routes');

    # Loading installed Addons config
    my $addons_config = $self->model('data-configure')->addons;

    # Initialize all addons
    $self->addons->init($addons_config) unless $ENV{MOJO_ADDON_TEST_MODE};
}

1;
