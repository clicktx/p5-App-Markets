package Markets::App::Common;
use Mojo::Base 'Mojolicious';

use Markets::Addons;

# use DBIx::QueryLog;
$ENV{DBIC_TRACE}            = 1;
$ENV{DBIX_QUERYLOG_COMPACT} = 1;
$ENV{DBIX_QUERYLOG_USEQQ}   = 1;

# $ENV{DBIX_QUERYLOG_EXPLAIN} = 1;

has schema => sub {
    say "+++++ DBIC +++++";    # debug
    my $self         = shift;
    my $schema_class = "Markets::Schema";
    eval "require $schema_class" or die "Could not load Schema Class ($schema_class). $@\n";

    say "      connecting db.";    # debug
    my $conf   = $self->config('db') or die "Missing configuration for db";
    my $dsn    = _dsn($conf);
    my $schema = $schema_class->connect($dsn)
      or die "Could not connect to $schema_class using DSN ";
    return $schema;
};

# has restart_app => sub { system shift->home . "/script/appctl --restart" };
has restart_app => sub { system "touch " . __FILE__ };    # 本番用に変更する
has addons      => sub { Markets::Addons->new(@_) };

sub initialize_app {
    my $self = shift;
    my $home = $self->home;
    my $mode = $self->mode;

    # SQL debug log
    # $DBIx::QueryLog::OUTPUT = sub {
    #     my %args = @_;
    #
    #     # printf 'sql: %s', $args{sql};
    #     $self->log->debug( "sql:\n" . $args{sql} );
    # };

    # change log dir
    $self->log->path( $home->rel_file("var/log/$mode.log") )
      if -d $home->rel_file('var/log') && -w _;

    my $config_path = $home->rel_file("config/$mode.conf");
    $self->plugin( Config => { file => $config_path } );

    # Models
    $self->plugin( Model => { namespaces => ['Markets::Model'] } );

    # Default Helpers
    $self->plugin('Markets::DefaultHelpers');

    # Preferences
    my $pref = $self->model('pref')->load_pref;
    $pref->{LINK_NAME} = 'リンク先';          # e.g.
    $pref->{ROOT_URL}  = 'http://google.com/';    # e.g.

    # TimeZone
    # my $time_zone = 'Asia/Tokyo';                 # from preference
    # $self->schema->time_zone($time_zone);

    # default cookie
    $self->sessions->cookie_name('session');
    $self->secrets( ['aaabbbccc'] );    #           change this!

    # password
    $self->plugin('Scrypt');

    # session
    $self->plugin( 'Markets::Session' => { expires_delta => 3600 } );

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
    my $locale_dir = Mojo::File::path( $home, 'share', 'locale' );
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
            $c->app->addons->filter_hook->emit( filter_form => $c )
              unless $c->stash('mojo.static');
        }
    );
}

sub _dsn {
    my $conf = shift;
    my $dsn;
    if ( $ENV{TEST_MYSQL} ) { $dsn = $ENV{TEST_MYSQL} }
    else {
        $dsn =
            "DBI:$conf->{dbtype}:dbname=$conf->{dbname};"
          . "host=$conf->{host};port=$conf->{port};"
          . "user=$conf->{user};password=$conf->{password};";
    }
    return $dsn;
}

1;
