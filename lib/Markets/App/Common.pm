package Markets::App::Common;
use Mojo::Base 'Mojolicious';

use File::Spec;
use DBI;
use Markets::Util;
use Markets::DB;
use Markets::Addons;

has dbh => sub {
    my $self = shift;
    my $conf = $self->config->{db} or die "Missing configuration for db";
    my $dsn  = $self->dsn($conf);
    my $dbh  = DBI->connect( $dsn, { RaiseError => 1 } ) or die $DBI::errstr;
    say "connecting DB.";                            # debug
    say '$app->dbh => ' . $dbh . 'on Markets.pm';    # debug
    return $dbh;
};
has db => sub {
    say "+++++ DB. +++++";                           # debug
    my $db = Markets::DB->new( dbh => shift->dbh );
    return $db;
};
has addons => sub { Markets::Addons->new( app => shift ) };
has action_hook => sub { shift->addons->action_hook(@_) };
has filter_hook => sub { shift->addons->filter_hook(@_) };
has restart_app => sub { system shift->home . "/script/appctl --restart" };

sub register_addon { shift->addons->register_addon( shift, @_ ) }

sub dsn {
    my ( $self, $conf ) = @_;
    my $dsn;
    if ( $ENV{TEST_MYSQL} ) {
        $dsn = $ENV{TEST_MYSQL};
    }
    else {
        $dsn =
            "DBI:$conf->{dbtype}:dbname=$conf->{dbname};"
          . "host=$conf->{host};port=$conf->{port};"
          . "user=$conf->{user};password=$conf->{password};";
    }
    return $dsn;
}

sub initialize_app {
    my $self = shift;
    my $home = $self->home;
    my $mode = $self->mode;

    # change log dir
    $self->log->path( $home->rel_file("var/log/$mode.log") )
      if -d $home->rel_file('var/log') && -w _;

    my $config_path = $home->rel_file("config/$mode.conf");
    $self->plugin( Config => { file => $config_path } );

    # Application defaults
    $self->config(
        app_defaults => {
            ADDONS_DIR => 'addons',
        }
    );

    # Models
    $self->plugin( Model => { namespaces => ['Markets::Model'] } );

    # Default Helpers
    $self->plugin('Markets::DefaultHelpers');

    # constants
    my $constants = $self->model('data-constant')->load;
    $constants->{LINK_NAME} = 'リンク先';          # ex)
    $constants->{ROOT_URL}  = 'http://google.com/';    # ex)
    $self->defaults( constants => $constants );

    # $self->config( constants => $self->model('data-constant')->load );

    # load config after. option schema loading.
    # TODO: issue #6 自動で読み込むようにする
    my $more_schema_classes_from_db =
      [qw /Markets::DB::Schema::Session Markets::DB::Schema::Addons/];
    $self->db->merge_schema($more_schema_classes_from_db);

    # default cookie
    $self->sessions->cookie_name('session');
    $self->secrets( ['aaabbbccc'] );    #           change this!

    # session
    $self->plugin(
        'Markets::Session' => {
            expires_delta => 3600,
        }
    );

    # locale
    $ENV{MOJO_I18N_DEBUG} = $mode eq 'development' ? 1 : 0;
    $self->plugin(
        'Markets::I18N',
        {
            # file_type => 'po',    # or 'mo'. default: po
            default   => 'en',               # default en
            languages => [qw( en ja de )],

            # Mojolicious::Plugin::I18N like options
            no_header_detect  => 1,                   # option. default: false
            support_url_langs => [qw( en ja de )],    # option
        }
    );

    # loading lexicon files
    my $locale_dir = File::Spec->catdir( $home, 'share', 'locale' );
    $self->lexicon(
        {
            search_dirs => [$locale_dir],

            # gettext_to_maketext => $boolean,                    # option
            # decode              => $boolean,                    # option
            data => [ '*::' => '*.po' ],
        }
    ) if -d $locale_dir;

    # Form Frameworks
    $self->plugin( 'Markets::Form', methods => { valid => 'form_valid', errors => 'form_errors' } );

    # Add before/after action hook
    # MEMO: Mojoliciou::Controllerの挙動を変更
    $self->hook(
        around_action => sub {
            my ( $next, $c, $action, $last ) = @_;
            return $next->() unless $last;

            say "hook! around_action from Markets::App::Common";    # debug
            if ( $c->can('process') ) {
                $c->process($action);
            }
            else {
                $c->app->log->warn('Controller class shoud inheritance of "Markets::Controller".');
                $c->$action;
            }
        }
    );

    $self->hook(
        before_routes => sub {
            my $c = shift;

            # Emit filter hook (ignore static files)
            say "hook! before_routes";    # debug
            say "... This route is dynamic" unless ( $c->stash('mojo.static') );
            $c->app->filter_hook->emit( filter_form => $c )
              unless $c->stash('mojo.static');
        }
    );
}

1;
